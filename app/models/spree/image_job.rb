class Spree::ImageJob < Struct.new(:product_id)
  def perform
    Spree::CustomProduct.find(self.product_id).regenerate_styles!
  end
end