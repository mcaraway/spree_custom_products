class Spree::ImageJob < Struct.new(:image_id)
  def perform
    Spree::Image.find(self.image_id).regenerate_styles!
  end
end