Spree::Product.class_eval do
  belongs_to :user
  attr_accessible :public, :final, :customizable

  def is_public?
    public
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
    logger.debug "********** variants = " + variants.size.to_s
    p = self.dup
    p.name = name
    p.deleted_at = nil
    p.created_at = p.updated_at = nil
    p.taxons = taxons

    p.product_properties = product_properties.map { |q| r = q.dup; r.created_at = r.updated_at = nil; r }

    image_dup = lambda { |i| j = i.dup; j.attachment = i.attachment.clone; j }

    variant = master.dup
    variant.sku = get_customized_sku(master.sku)
    variant.deleted_at = nil
    variant.images = master.images.map { |i| image_dup.call i }
    variant.price = master.price
    variant.currency = master.currency
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
end