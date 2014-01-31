Spree::Product.class_eval do
  belongs_to :user
  has_and_belongs_to_many :blendable_taxons, :join_table => 'spree_blendable_products_taxons'

  ##attr_accessible :public, :final, :label_template_id, :processing, :customizable

  validate :validate_minimum_image_size
  validate :must_have_blend
  validate :check_final_state
  
  def validate_minimum_image_size
    if is_custom?
      requiredTinImageWidth = 347
      requiredTinImageHeight = 300
      requiredTagImageWidth = 120
      requiredTagImageHeight = 100
      if (! @tin_image.nil?)
        unless (@tin_image.attachment_width == requiredTinImageWidth && @tin_image.attachment_height == requiredTinImageHeight )
          logger.debug "*** Naughty you... the tin image designs should be #{requiredTinImageWidth}px x #{requiredTinImageHeight}px."
          errors.add :tin_image, "Naughty you... the tin image designs should be #{requiredTinImageWidth}px x #{requiredTinImageHeight}px."
        end
      end

      if (! @tag_image.nil?)
        unless (@tag_image.attachment_width == requiredTagImageWidth && @tag_image.attachment_height == requiredTagImageHeight )
          logger.debug "*** Naughty you... the tag image designs should be #{requiredTagImageWidth}px x #{requiredTagImageHeight}px."
          errors.add :tag_image, "Naughty you... the tag image designs should be #{requiredTagImageWidth}px x #{requiredTagImageHeight}px."
        end
      end
    end
  end

  def requiredTinImageWidth
    347
  end

  def requiredTinImageHeight
    300
  end

  def move_to(user)
    self.update(user_id: user.id)
  end

  def is_public?
    public
  end

  def check_final_state
    if is_custom?
      if final
        if name == nil
          errors.add :name, "Your blend can not be made final until it has a name."
        end
        if description == nil
          errors.add :description, "Your blend can not be made final until it has a description."
        end
        if !(has_tin_image?)
          errors.add :images, "Your blend can not be made final until it has a tin image."
        end
        if !has_flavors?
          errors.add :blend, "Your blend can not be made final until it has at least one flavor."
        end
      end
    end
  end

  def has_flavors?
    @has_flavors = false
    product_properties.each do |property|

      if (property.property_name.index("percent") == nil)
        if property.value != nil and property.value != ""
          @has_flavors = true
        end
      end
      logger.debug "*** Hasflavors #{@has_flavors}"
    end
    @has_flavors
  end

  add_search_scope :iscustom do |value|
    logger.debug "****** :custom search is #{value}"
    if value == nil or value == "false"
      logger.debug "****** :custom search is NULL"
      where("spree_products.user_id IS NULL")
    else
      logger.debug "****** :custom search is NOT NULL"
      where("spree_products.user_id IS NOT NULL")
    end
  end

  add_search_scope :ispublic do |value|
    logger.debug "****** :public search is #{value}"
    value = value == nil ? true : value
    where(:public => value)
  end

  add_search_scope :isfinal do |value|
    logger.debug "****** :final search is #{value}"
    value = value == nil ? true : value
    where(:final => value)
  end

  def is_custom?
    sku.include? custom_sku_indicator
  end

  def is_customized?
    sku.include? customized_sku_indicator
  end

  def is_customizable?
    customizable  
  end
  
  def new_product_property=(product_property_attributes)
    logger.debug "Setting attributes #{product_property_attributes}"
    product_property_attributes.each do |attributes|
      product_properties.build(attributes)
    end
  end

  def blend
    blend = ""
    product_properties.each do |property|
      if (property.property_name.index("name") != nil)
        prefix = property.property_name[0, 7]
        product_properties.each do |percent_property|
          if (percent_property.property_name == prefix+"percent" and percent_property.value != "0")
            blend += percent_property.value + "% " +
            property.value + " / "
          end
        end
      end
    end

    if (blend =~ / \/ $/)
    blend = blend.slice(0,blend.length-3)
    end

    blend == "" ? "_" : blend
  end

  def create_customized_copy(duplicate_variants = false)
    logger.debug "********** creating customized copy for  = " + id.to_s
    p = self.dup
    p.name = name
    p.description = ""
    p.deleted_at = nil
    p.created_at = p.updated_at = nil
    p.taxons = taxons
    p.public = false

    p.product_properties = product_properties.map { |q| r = q.dup; r.created_at = r.updated_at = nil; r }

    image_dup = lambda { |i| j = i.dup; j.attachment = i.attachment.clone; j }

    variant = master.dup
    variant.sku = get_customized_sku(master.sku)
    variant.deleted_at = nil
    variant.images = master.images.map { |i| image_dup.call i }
    variant.price = master.price
    variant.currency = master.currency
    variant.product_id = p.id
    p.master = variant

    # don't dup the actual variants, just the characterising types
    p.option_types = option_types if has_variants?

    # allow site to do some customization
    p.send(:duplicate_extra, self) if p.respond_to?(:duplicate_extra)

    p.save!

    if (duplicate_variants)
      copy_variants(p)
      p = Spree::Product.find_by_id(p.id)
    end
    p
  end

  def copy_variants(to)
    logger.debug "********** duplicating variants as well"
    logger.debug "********** variants = " + variants.size.to_s
    variants.each do |var|
      logger.debug "********** duplicating variants: " + var.id.to_s
      var_dup = var.dup
      var_dup.product_id = to.id
      var_dup.sku = get_customized_sku(var.sku)
      var_dup.option_values = var.option_values

      #duplicate prices
      #price_dup = lambda { |i| j = i.dup; j }
      #var_dup.prices = var.prices.map { |i| price_dup.call i }
      var_dup.price = var.price

      #duplicate inventory units
      #inv_dup = lambda { |i| j = i.dup; j }
      #var_dup.inventory_units = var.inventory_units.map { |i| inv_dup.call i}

      #duplicate line_items
      #line_items_dup = lambda { |i| j = i.dup; j }
      #var_dup.line_items = var.line_items.map { |i| line_items_dup.call i}

      var.save!

      to.variants << var_dup
    end
    to
  end

  def get_custom_sku
    count = Spree::Variant.count_by_sql("select count(*) from spree_variants where sku like '"+custom_sku_indicator+"%'")

    logger.debug "****** count Products with sku "+custom_sku_indicator+"% = #{count}"

    new_sku = custom_sku_indicator+count.to_s().rjust(8, '0')

    new_sku
  end

  def get_customized_sku (old_sku)
    count = Spree::Variant.count_by_sql("select count(*) from spree_variants where sku like '"+old_sku+customized_sku_indicator+"%'")

    logger.debug "****** count Products with sku "+old_sku+customized_sku_indicator+"% = #{count}"

    new_sku = old_sku +customized_sku_indicator+count.to_s().rjust(8, '0')

    new_sku
  end

  def update_viewables
    refresh_images
  end

  def refresh_images
    if images[0] != nil
      logger.info("******** creating delayed job for reprocessing image processing")
      Delayed::Job.enqueue Spree::ReprocessImagesJob.new(images[0].id)
    end
  end

  def customized_sku_indicator
    "-cust-"
  end

  def custom_sku_indicator
    "CUST-"
  end
  
    def flavors
    flavors = Hash.new
    product_properties.each do |property|
      if (property.property_name.index("flavor") != nil)
      flavors[property.property_name] = property.value
      end
    end
    flavors
  end

  def has_tin_image?
    !(images.empty?)
  end

  def has_tag_image?
    images.length > 1
  end

  def tin_image
    if images.empty?
      image_tag "/assets/CustomTeaLabel.png", :size => "82x186"
    else
      image_tag images.first.attachment.url(:small), :size => "82x186"
    end
  end

  def tag_image
    if images.empty? or images.length < 2
      image_tag "/assets/TeaTagLabel.png", :size => "50x42"
    else
      image_tag images[1].attachment.url(:small), :size => "50x42"
    end
  end

  def tin_image=(params)
    @tin_image = Spree::Image.create( params )
  end

  def tag_image=(params)
    @tag_image = Spree::Image.create( params )
  end

  def update_viewables
    if @tin_image != nil
      @tin_image.viewable = master
    @tin_image.save
    end

    if @tag_image != nil
      @tag_image.viewable = master
    @tag_image.save
    end

    refresh_tin_image
  end

  def refresh_tin_image
    if images[0] != nil
      logger.info("******** creating delayed job for reprocessing image processing")
      Delayed::Job.enqueue Spree::ReprocessImagesJob.new(id)
    end
  end
  #attr_accessible :tin_image, :tag_image, :blend

  def must_have_blend
    if !has_flavors? && is_custom?
      logger.debug "You must have at least one flavor"
      errors.add :blend, "You must have at least one flavor"
    end
  end

  def option_values
    @_option_values ||= Spree::OptionValue.for_product(self).order(:position).sort_by {|ov| ov.option_type.position }
  end

  def grouped_option_values
    @_grouped_option_values ||= option_values.group_by(&:option_type)
  end

  def variants_for_option_value(value)
    @_variant_option_values ||= variants.includes(:option_values).all
    @_variant_option_values.select { |i| i.option_value_ids.include?(value.id) }
  end

  def variant_options_hash
    return @_variant_options_hash if @_variant_options_hash
    hash = {}
    variants.includes(:option_values).each do |variant|
      variant.option_values.each do |ov|
        otid = ov.option_type_id.to_s
        ovid = ov.id.to_s
        hash[otid] ||= {}
        hash[otid][ovid] ||= {}
        hash[otid][ovid][variant.id.to_s] = variant.to_hash
      end
    end
    @_variant_options_hash = hash
  end
end