class Spree::CustomProduct < ActiveRecord::Base
  has_one :image, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  has_many :line_item
  
  validate :has_flavors?, if: :require_flavors
  validates :name, presence: true, if: :require_label_info
  validates :description, presence: true, if: :require_label_info
  validate :validate_has_image, if: :require_label_info
  
  make_permalink order: :name
   
  def require_flavors
    !step.blank?
  end
  
  def require_label_info
    !step.blank? and step != 'pick_flavors'
  end
  
  def has_flavors?
    if (flavor_1_name.blank?)
      errors.add(:base, Spree.t(:missing_flavors)) and return false
    end
  end
    
  def to_param
    permalink.present? ? permalink : (permalink_was || (name == nil ? nil : name.to_s.to_url))
  end
  
  def validate_has_image
    if !has_image?
      errors.add(:base, Spree.t(:missing_image)) and return false
    end
  end

  def has_image?
    puts "******** image == nil: " + (image == nil ? "nil" : "not nil") + " image.id: " + (image.blank? ? "nil" : image.id.to_s)
    image != nil and image.id != nil
  end

  def is_final?
    final != nil && final
  end

  def blend
    return "" if flavor_1_name == nil;
    blend = flavor_1_name + " " + flavor_1_percentage.to_s + "%"
    blend += (flavor_2_name.blank? ? "" : " / " + flavor_2_name + " " + flavor_2_percentage.to_s + "%")
    blend += (flavor_3_name.blank? ? "" : " / " + flavor_3_name + " " + flavor_3_percentage.to_s + "%")
  end

  def get_custom_sku
    count = Spree::Variant.count_by_sql("select count(*) from spree_custom_products where sku like '"+custom_sku_indicator+"%'")

    logger.debug "****** count Products with sku "+custom_sku_indicator+"% = #{count}"

    new_sku = custom_sku_indicator+count.to_s().rjust(8, '0')

    new_sku
  end

  def get_customized_sku (old_sku)
    count = Spree::Variant.count_by_sql("select count(*) from spree_custom_products where sku like '"+old_sku+customized_sku_indicator+"%'")

    logger.debug "****** count Products with sku "+old_sku+customized_sku_indicator+"% = #{count}"

    new_sku = old_sku +customized_sku_indicator+count.to_s().rjust(8, '0')

    new_sku
  end

  def refresh_images
    if image != nil
      logger.info("******** creating delayed job for reprocessing image processing")
      Delayed::Job.enqueue Spree::ReprocessImagesJob.new(image.id)
    end
  end

  def customized_sku_indicator
    "-cust-"
  end

  def custom_sku_indicator
    "CUST-"
  end

  def to_s
    blend
  end
end
