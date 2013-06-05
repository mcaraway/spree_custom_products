module Paperclip
  class LabelThumbnail < Processor
    # Handles compositing of images that are uploaded.
    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :name, :tin_path, :tin_fade_path, :description, :blend, :generate_tin_image
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
      @name             = options[:name]
      @description      = options[:description]
      @blend            = options[:blend]
      @tin_path         = options[:tin_path]
      @generate_tin_image = options[:generate_tin_image]
      @tin_fade_path = options[:tin_fade_path]
    end

    # Performs the conversion of the +file+. Returns the Tempfile
    # that contains the new image.
    def make
      Paperclip.log("***********  Label Thumbnail Processor...")
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode

      # first create the name text image
      nameImg = createText(name, "72", "")

      # next create the description text image
      descImg = createText(description, "36", "800x")

      # next create the blend text image
      blendImg = createText(blend, "72", "")

      # now composite name text onto comp
      comp = compositeFiles(nameImg, @file, "820x100!+40+40")

      # now composite blend text onto comp
      comp2 = compositeFiles(blendImg, comp, "810x50!+50+1050")

      #now composite the description onto the dst
      dst = compositeFiles(descImg, comp2, "820x300+50+865")

      if generate_tin_image
        dst = compositeFiles(dst, tin_path, "332x436!+234+139")
        dst = compositeFiles(tin_fade_path, dst, "800x800!+0+0")
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
        params = "-background none -fill black -font Constantia -pointsize #{pointsize} label:\"#{text}\" #{tofile(textImg)}"
      else
        params = "-background none -fill black -font Constantia -pointsize #{pointsize} -size #{size_for_caption} caption:\"#{text}\" #{tofile(textImg)}"
      end

      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error creating the text img params #{params}" if @whiny
      end

      textImg
    end

    def fromfile
      File.expand_path(@file.path)
    end

    def tofile(destination)
      destination.is_a?(String) ? destination : File.expand_path(destination.path)
    end

  end
end