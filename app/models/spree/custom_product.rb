class Spree::CustomProduct < ActiveRecord::Base
  has_attached_file :label_image,
                    :processors => [:thumbnail, :thumbnail],
                    :styles => {
                      :label  => {
                        :geometry =>'600x800',
                        :format => :png,
                        :name => "Tea Flavor",
                        :description => "This is where you describe how wonderful your tea blend really is.",
                        :blend => "50% First Flavor / 25% Second Flavor / 25% Third Flavor",
                        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
                        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
                        :generate_tin_image => false
                      },
                      :thumb => {
                        :geometry =>'75x100',
                        :format => :png,
                        :name => "Tea Flavor",
                        :description => "This is where you describe how wonderful your tea blend really is.",
                        :blend => "50% First Flavor / 25% Second Flavor / 25% Third Flavor",
                        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
                        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
                        :generate_tin_image => false
                      },
                      :product => {
                        :geometry =>'240x240',
                        :format => :png,
                        :name => "Tea Flavor",
                        :description => "This is where you describe how wonderful your tea blend really is.",
                        :blend => "50% First Flavor / 25% Second Flavor / 25% Third Flavor",
                        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
                        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
                        :generate_tin_image => true
                      }
                    },
                    :default_style => :label,
                    :url => "/spree/custom_products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/spree/custom_products/:id/:style/:basename.:extension",
                    :convert_options => { :all => '-strip -auto-orient' }
  has_many :line_item
  
  validate :has_flavors?, if: :require_flavors
  validates :name, presence: true, if: :require_label_info
  validates :description, presence: true, if: :require_label_info
  validate :validate_has_image, if: :require_label_info
  
  make_permalink order: :name

 if Rails.env.production?
    include Spree::Core::S3Support
    supports_s3 :label_image

    # Spree::LabelTemplate.attachment_definitions[:label_image][:styles] = { :label  => '600x800', :thumb => '75x100' }
    # Spree::LabelTemplate.attachment_definitions[:label_image][:path] = ":rails_root/public/spree/label_templates/:id/:style/:basename.:extension"
    # Spree::LabelTemplate.attachment_definitions[:label_image][:url] = "/spree/label_templates/:id/:style/:basename.:extension"
    # Spree::LabelTemplate.attachment_definitions[:label_image][:default_url] = "/spree/label_templates/:id/:style/:basename.:extension"
    # Spree::LabelTemplate.attachment_definitions[:label_image][:default_style] = "label"
  end

  def find_dimensions
    temporary = label_image.queued_for_write[:original]
    filename = temporary.path unless temporary.nil?
    filename = label_image.path if filename.blank?
    geometry = Paperclip::Geometry.from_file(filename)
    self.label_image_width  = geometry.width
    self.label_image_height = geometry.height
  end

  # if there are errors from the plugin, then add a more meaningful message
  def no_attachment_errors
    unless label_image.errors.empty?
      # uncomment this to get rid of the less-than-useful interrim messages
      # errors.clear
      errors.add :label_image, "Paperclip returned errors for file '#{label_image_file_name}' - check ImageMagick installation or image source file."
    false
    end
  end
  
 # cancel post-processing now, and set flag...
  before_label_image_post_process do |custom_product|
    puts "******* before_label_image_post_process"
    if custom_product.label_image_changed?
      custom_product.processing = true
      false # halts processing
    end
  end
 
  # ...and perform after save in background
  after_save do |custom_product| 
    puts "******* after_save"
    if custom_product.label_image_changed? && custom_product.processing == true
      Delayed::Job.enqueue Spree::ImageJob.new(custom_product.id)
    end
  end
 
  # generate styles (downloads original first)
  def regenerate_styles!
    logger.debug("******** in regenerate")
    self.label_image.reprocess! 
    self.processing = false   
    self.save(:validate=> false)
  end  
  
  # detect if our label_image file has changed
  def label_image_changed?
    logger.debug("******** self.label_image_file_size_changed? = " + (self.label_image_size_changed?).to_s)
    logger.debug("******** self.label_image_file_name_changed? = " + (self.label_image_file_name_changed?).to_s)
    logger.debug("******** self.label_image_content_type_changed? = " + (self.label_image_content_type_changed?).to_s)
    self.label_image_size_changed? || 
    self.label_image_file_name_changed? ||
    self.label_image_content_type_changed?
  end 
       
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
    if self.label_image_file_name.blank?
      errors.add(:base, Spree.t(:missing_image)) and return false
    end
  end

  def has_image?
    !label_image_file_name.blank? and processing != nil and processing == false
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
