Spree::BaseHelper.class_eval do


  def blend_img (sku)
    src = "https://s3.amazonaws.com/uniqteas/product_images/" + sku  + ".jpg"
    image_tag src, :size => "150x150"
  end
  

  def link_to_toggle(icon_name, text, url, options = {})
    options[:class] = (options[:class].to_s + " icon_link with-tip #{icon_name}").strip
    options[:class] += ' no-text'
    options[:title] = text 
    link_to('', url, options)
  end
  
  def product_image(product, options = {})
    if product.images.empty?
      options.reverse_merge! :alt => product.name
      options.reverse_merge! :size => "600x600"
      image_tag "noimage/no-tin-image.png", options
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag product.images.first.attachment.url(:large), options
    end
  end

  def original_image(product, options = {})
    if product.images.empty?
      options.reverse_merge! :alt => product.name 
      options.reverse_merge! :size => "240x240"
      image_tag "noimage/no-tin-image.png", options
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "225x300"
      image_tag product.images.first.attachment.url(:original), options
    end
  end
  
  def pouch_image(product, options = {})
    if product.images.empty?
      options.reverse_merge! :alt => product.name 
      options.reverse_merge! :size => "240x240"
      image_tag "noimage/no-tin-image.png", options
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "240x240"
      image_tag product.images.first.attachment.url(:pouch), options
    end
  end
  
  def tin_image(product, options = {})
    if product.images.empty?
      options.reverse_merge! :alt => product.name 
      options.reverse_merge! :size => "240x240"
      image_tag "noimage/no-tin-image.png", options
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "240x240"
      image_tag product.images.first.attachment.url(:tin), options
    end
  end

  def large_product_image(product, options = {})
    if product.images.empty?
      options.reverse_merge! :alt => product.name
      options.reverse_merge! :size => "400x400"
      image_tag "noimage/no-tin-image.png", options
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "400x400"
      image_tag product.images.first.attachment.url(:large), options
    end
  end

  def mini_image(product, options = {})
    if product.images.empty?
      image_tag "noimage/no-tin-image.png", :size => "48x48", :alt => product.name
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "48x48"
      image_tag product.images.first.attachment.url(:mini), options
    end
  end

  def small_image(product, options = {})
    if product.images.empty?
      image_tag "noimage/no-tin-image.png", :size => "100x100", :alt => product.name
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag product.images.first.attachment.url(:small), options
    end
  end

  def large_image(product, options = {})
    if product.images.empty?
      image_tag "noimage/no-tin-image.png", :size => "600x600", :alt => product.name
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag product.images.first.attachment.url(:large), options
    end
  end

  def mini_tea_tin_image (product)
    if product.images.empty?
      image_tag "/assets/noimage/no-tin-image.png", :size => "94x71", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:original), :size => "94x71", :alt => product.name
    end
  end

  def small_tea_tin_image (product)
    if product.images.empty?
      image_tag "/assets/CustomTeaLabel.png", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:original), :alt => product.name
    end
  end

  def small_product_label_image (product)
    if product.images.empty?
      image_tag "/assets/CustomTeaLabel.png", :size => "225x300", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:label), :size => "225x300", :alt => product.name
    end
  end
    
  def small_tea_tag_image (product)
    if product.images[1] == nil
      image_tag "/assets/TeaTagLabel.png", :size => "50x42"
    else
      image_tag product.images.first.attachment.url(:small), :size => "50x42"
    end
  end

  def xmini_tea_tag_image (product, options = {})
    if product.images.empty?
      image_tag "/assets/TeaTagLabel.png", :size => "37x31", :alt => product.name
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "37x31"
      image_tag product.images.first.attachment.url(:small), options
    end
  end


end