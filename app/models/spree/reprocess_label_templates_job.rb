class Spree::ReprocessLabelTemplatesJob < Struct.new(:image_id)
  def perform
    @label_templates = Spree::LabelTemplate.all

    @label_templates.each do |template|
      template.label_image.reprocess!
    end
  end
end