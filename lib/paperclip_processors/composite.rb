module Paperclip
  class Composite < Processor
    # Handles compositing of images that are uploaded.
    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :tin_path, :tin_fade_path, :label_template_path, :variant_id, :label_image_remote_url, :generate_tin_image
    def initialize file, options = {}, attachment = nil
      super
      geometry          = options[:geometry]
      @file             = file
      @target_geometry  = Geometry.parse geometry
      @current_geometry = Geometry.from_file @file
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
      @format           = options[:format]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @tin_path         = options[:tin_path]
      @label_template_path = options[:label_template_path]
      @variant_id      = options[:variant_id]
      @label_image_remote_url = options[:label_image_remote_url]
      @generate_tin_image = options[:generate_tin_image]
      @tin_fade_path = options[:tin_fade_path]
    end

    # Performs the conversion of the +file+. Returns the Tempfile
    # that contains the new image.
    def make
      Paperclip.log("***********  Product is custom!  Compositing...")
      nameImg = createText(productName, "36", "")

      # next create the description text image
      descImg = createText(productDescription, "18", "400x")

      # next create the blend text image
      blendImg = createText(productBlend, "36", "")

      # now composite name text onto template
      dst = compositeFiles(nameImg, label_image_remote_url.blank? ? label_template_path : file , "410x50!+20+20")

      # now composite blend text onto comp
      dst = compositeFiles(blendImg, dst, "405x25!+25+525")

      # now composite the description onto the dst
      dst = compositeFiles(descImg, dst, "400x93!+25+433")

      # now composite the image onto the label
      if label_image_remote_url.blank?
        dst = compositeFiles(file, dst, "411x314!+21+86")
      end

      if generate_tin_image
        dst = compositeFiles(dst, tin_path, "249x327!+176+104")
        dst = compositeFiles(tin_fade_path, dst, "600x600!+0+0")
      end

      dst
    end

    def compositeFiles(file1, file2, location)
      dst = Tempfile.new(["text",".png"])
      dst.binmode

      command = "composite"
      params = "-geometry #{location} #{tofile(file1)} #{tofile(file2)} #{tofile(dst)}"
      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error compositing two files with params #{params}" if @whiny
      end

      dst
    end

    def createText(text, pointsize, size_for_caption)
      textImg = Tempfile.new(["text",".png"])
      textImg.binmode

      command = "convert"
      params = ""
      if size_for_caption.blank?
        params = "-background none -fill black -font Arial -pointsize #{pointsize} label:\"#{text}\" #{tofile(textImg)}"
      else
        params = "-background none -fill black -font Arial -pointsize #{pointsize} -size #{size_for_caption} caption:\"#{text}\" #{tofile(textImg)}"
      end

      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error creating the text img params #{params}" if @whiny
      end

      textImg
    end

    def compositeTextToFile(text, file, location)
      dst = Tempfile.new(["tempDst",".png"])
      dst.binmode

      # composite the name onto the destination image
      # first create the text image
      textImg = Tempfile.new(["text",".png"])
      textImg.binmode

      command = "convert"
      params = "-background none -fill black -font Arial -pointsize 12 label:\"#{text}\" #{tofile(textImg)}"
      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error creating the text img params #{params}" if @whiny
      end

      # now composite text onto dst
      command = "composite"
      params = "-geometry " + location +" #{tofile(textImg)} #{tofile(file)} #{tofile(dst)}"
      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error compositing the text onto the template with params #{params}" if @whiny
      end

      dst
    end

    def fromfile
      File.expand_path(@file.path)
    end

    def tofile(destination)
      destination.is_a?(String) ? destination : File.expand_path(destination.path)
    end

    def productName
      variant = Spree::Variant.find_by_id(@variant_id)
      variant ? variant.name.strip : "Tea Name"
    end

    def productDescription
      variant = Spree::Variant.find_by_id(@variant_id)
      variant ? variant.description.strip : "Tea Description"
    end

    def productBlend
      variant = Spree::Variant.find_by_id(@variant_id)
      product = variant ? Spree::Product.find(variant.product_id) : nil
      product ? product.blend.strip : "Tea Blend"
    end
  end
end