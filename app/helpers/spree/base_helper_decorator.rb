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
  
  def custom_product_image(product, options = {})
    if !product.has_image?
      options.reverse_merge! :alt => product.name
      options.reverse_merge! :size => "600x600"
      image_tag "noimage/no-tin-image.png", options
    else
      image = product.image
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag product.image.attachment.url(:large), options
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
      image_tag image.first.attachment.url(:large), options
    end
  end

  def custom_product_mini_image(product, options = {})
    if !product.has_image?
      image_tag "noimage/no-tin-image.png", :size => "48x48", :alt => product.name
    else
      image = product.image
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "48x48"
      image_tag image.first.attachment.url(:mini), options
    end
  end

  def custom_product_small_image(product, options = {})
    if !product.has_image?
      image_tag "noimage/no-tin-image.png", :size => "100x100", :alt => product.name
    else
      image = product.image
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag image.attachment.url(:small), options
    end
  end

  def custom_product_large_image(product, options = {})
    if !product.has_image?
      image_tag "noimage/no-tin-image.png", :size => "600x600", :alt => product.name
    else
      image = product.image
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag product.images.first.attachment.url(:large), options
    end
  end

  def large_image(product, options = {})
    if product.images[1] == nil
      image_tag "noimage/no-tin-image.png", :size => "600x600", :alt => product.name
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag image.attachment.url(:large), options
    end
  end

  def mini_tea_tin_image (custom_product, options = {})
    if !custom_product.has_image?
      image_tag "/assets/noimage/no-tin-image.png", :size => "94x71", :alt => custom_product.name
    else
      image = custom_product.image
      options.reverse_merge! :alt => image.alt.blank? ? custom_product.name : image.alt
      options.reverse_merge! :size => "94x71"
      image_tag image.attachment.url(:original), options
    end
  end

  def small_tea_tin_image (custom_product)
    if custom_product.image == nil
      image_tag "/assets/CustomTeaLabel.png", :alt => custom_product.name
    else
      image_tag custom_product.image.attachment.url(:original), :alt => custom_product.name
    end
  end

  def small_product_label_image (custom_product, options = {})
    if !custom_product.has_image?
      options.reverse_merge! :alt => custom_product.name 
      options.reverse_merge! :size => "225x300"
      image_tag "/assets/CustomTeaLabel.png", options
    else
      image = custom_product.image
      options.reverse_merge! :alt => image.alt.blank? ? custom_product.name : image.alt
      options.reverse_merge! :size => "225x300"
      image_tag image.attachment.url(:original), options
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

  def get_star_rating(name, value)
    return "" if value == 0
    content_tag :tr do
      concat(content_tag :td, name+":", :style =>"width:20%;").
      concat(content_tag :td,(image_tag '/assets/store/star_'+value.to_s+'.png',width:"150px", height:"22px"))
    end  
  end
  
    # converts line breaks in product description into <p> tags (for html display purposes)
    def custom_product_description(product)
      if Spree::Config[:show_raw_product_description]
        raw(product.description)
      else
        raw(product.description.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>'))
      end
    end  
end