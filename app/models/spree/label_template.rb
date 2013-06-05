class Spree::LabelTemplate < ActiveRecord::Base
  attr_accessible :group, :name, :label_image
  has_attached_file :label_image,
                    :processors => [:label_thumbnail, :thumbnail],
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
                    :url => "/spree/label_templates/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/spree/label_templates/:id/:style/:basename.:extension",
                    :convert_options => { :all => '-strip -auto-orient' }
  # save the w,h of the original image (from which others can be calculated)
  # we need to look at the write-queue for images which have not been saved yet

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
  before_label_image_post_process do |image|
    if image.label_image_changed?
      image.processing = true
      false # halts processing
    end
  end
 
  # ...and perform after save in background
  after_save do |image| 
    if image.label_image_changed?
      Delayed::Job.enqueue Spree::ImageJob.new(image.id)
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
    logger.debug("******** self.label_image_file_size_changed? = " + (self.label_image_file_size_changed?).to_s)
    logger.debug("******** self.label_image_file_name_changed? = " + (self.label_image_file_name_changed?).to_s)
    logger.debug("******** self.label_image_content_type_changed? = " + (self.label_image_content_type_changed?).to_s)
    self.label_image_file_size_changed? || 
    self.label_image_file_name_changed? ||
    self.label_image_content_type_changed?
  end   
end
