Spree::BaseHelper.class_eval do
  def get_category_root
    Spree::Taxonomy.where(:name => 'Categories').includes(:root => :children).first.root
  end
  
  def categories_tree(root_taxon, current_taxon, max_level, current_level = 1)
    return '' if max_level < current_level || root_taxon.children.empty?
    css_class = current_level == 1 ? 'sf-menu' : ''
    content_tag :ul, :class => css_class do
      root_taxon.children.map do |taxon|
        css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'current' : nil
        content_tag :li, :class => css_class do
          link_to(taxon.name, seo_url(taxon)) +
          categories_tree(taxon, current_taxon, max_level, current_level + 1)
        end
      end.join("\n").html_safe
    end
  end

  def blend_img (sku)
    src = "https://s3.amazonaws.com/uniqteas/product_images/" + sku  + ".jpg"
    image_tag src, :size => "150x150"
  end
  
  def link_to_clone(resource, options={})
    options[:data] = {:action => 'clone'}
    link_to_with_icon('icon-copy', t(:clone), clone_admin_product_url(resource), options)
  end

  def link_to_new(resource)
    options[:data] = {:action => 'new'}
    link_to_with_icon('icon-plus', t(:new), edit_object_url(resource))
  end

  def link_to_edit(resource, options={})
    options[:data] = {:action => 'edit'}
    link_to_with_icon('icon-edit', t(:edit), edit_object_url(resource), options)
  end

  def link_to_edit_url(url, options={})
    options[:data] = {:action => 'edit'}
    link_to_with_icon('icon-edit', t(:edit), url, options)
  end

  def link_to_delete(resource, options={})
    url = options[:url] || object_url(resource)
    name = options[:name] || t(:delete)
    options[:class] = "delete-resource"
    options[:data] = { :confirm => t(:are_you_sure), :action => 'remove' }
    link_to_with_icon 'icon-trash', name, url, options
  end

  def link_to_with_icon(icon_name, text, url, options = {})
    options[:class] = (options[:class].to_s + " icon_link with-tip #{icon_name}").strip
    options[:class] += ' no-text' if options[:no_text]
    options[:title] = text if options[:no_text]
    text = options[:no_text] ? '' : raw("<span class='text'>#{text}</span>")
    options.delete(:no_text)
    link_to(text, url, options)
  end

  def link_to_toggle(icon_name, text, url, options = {})
    options[:class] = (options[:class].to_s + " icon_link with-tip #{icon_name}").strip
    options[:class] += ' no-text'
    options[:title] = text 
    text = ''
    link_to(text, url, options)
  end
  
  def icon(icon_name)
    icon_name ? content_tag(:i, '', :class => icon_name) : ''
  end

  def button(text, icon_name = nil, button_type = 'submit', options={})
    button_tag(text, options.merge(:type => button_type, :class => "#{icon_name} button"))
  end

  def button_link_to(text, url, html_options = {})
    if (html_options[:method] &&
    html_options[:method].to_s.downcase != 'get' &&
    !html_options[:remote])
      form_tag(url, :method => html_options.delete(:method)) do
        button(text, html_options.delete(:icon), nil, html_options)
      end
    else
      if html_options['data-update'].nil? && html_options[:remote]
        object_name, action = url.split('/')[-2..-1]
        html_options['data-update'] = [action, object_name.singularize].join('_')
      end

      html_options.delete('data-update') unless html_options['data-update']

      html_options[:class] = 'button'

      if html_options[:icon]
        html_options[:class] += " #{html_options[:icon]}"
      end
      link_to(text_for_button_link(text, html_options), url, html_options)
    end
  end

  def text_for_button_link(text, html_options)
    s = ''
    s << text
    raw(s)
  end

  def full_address(address)
    full_address = address.address2 == nil ? address.address1 : address.address1 + ', ' + address.address2
    full_address += ', ' + address.city + ', ' + address.state_text + ', ' + address.zipcode

    full_address
  end

  def product_image(product, options = {})
    if product.images.empty?
      options.reverse_merge! :alt => product.name 
      options.reverse_merge! :size => "240x240"
      image_tag "noimage/no-tin-image.png", options
    else
      image = product.images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options.reverse_merge! :size => "240x240"
      image_tag product.images.first.attachment.url(:product), options
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

  def large_large(product, options = {})
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
      image_tag "/assets/CustomTeaLabel.png", :size => "347x300", :alt => product.name
    else
      image_tag product.images.first.attachment.url(:original), :size => "347x300", :alt => product.name
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

  def button(text, icon_name = nil, button_type = 'submit', options={})
    button_tag(content_tag('span', icon(icon_name) + ' ' + text), options.merge(:type => button_type))
  end

  def icon(icon_name)
    icon_name ? image_tag("admin/icons/#{icon_name}.png") : ''
  end

  def link_to_add_fields(name, target)
    link_to icon('add') + name, 'javascript:', :data => { :target => target }, :class => "add_fields"
  end

  def breadcrumbs(taxon = nil, product = nil, sep = "&nbsp;&raquo;&nbsp;")
    logger.debug "****** entered bradcrumbs taxon = #{taxon}"
    if String === product
      sep = product
      product = nil
    end

    return "" unless taxon || product || current_page?(products_path)

    session['last_crumb'] = taxon ? taxon.permalink : nil
    sep = raw(sep)
    crumbs = [content_tag(:li, link_to(t(:home) , root_path) + sep)]

    if taxon
      crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + sep) } unless taxon.ancestors.empty?
      if product
        crumbs << content_tag(:li, link_to(taxon.name , seo_url(taxon)) + sep)
        crumbs << content_tag(:li, content_tag(:span, product.name))
      else
        crumbs << content_tag(:li, content_tag(:span, taxon.name))
      end
    elsif product
      crumbs << content_tag(:li, link_to(t('products') , products_path) + sep)
      crumbs << content_tag(:li, content_tag(:span, product.name))
    else
      crumbs << content_tag(:li, content_tag(:span, t('products')))
    end
    crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), :class => 'inline')
    content_tag(:div, crumb_list, :id => 'breadcrumbs')
  end

  def last_crumb_path
    plink = session['last_crumb']
    if plink && taxon = Spree::Taxon.find_by_permalink(plink)
      seo_url(taxon)
    else
      products_path
    end
  end

  def mobile_logo(image_path=Spree::Config[:logo])
    link_to image_tag(image_path, :size => '54x20'), root_path
  end

end