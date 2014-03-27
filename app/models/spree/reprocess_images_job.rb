class Spree::ReprocessImagesJob < Struct.new(:product_id)
  def perform
    if (self.product_id)
      create_sub_job(Spree::Product.find(self.product_id))
    else
      @products = Spree::Product.all

      @products.each do |product|
        if !product.deleted_at.nil?
        next
        end
        create_sub_job(product)
      end
      
      @custom_products = Spree::CustomProduct.all
      
      @custom_products.each do |product|
        if !product.deleted_at.nil?
        next
        end
        Delayed::Job.enqueue Spree::ImageJob.new(product.id)
      end
    end
  end

  def create_sub_job (product)
    Delayed::Job.enqueue Spree::ReprocessProductImageJob.new(product.id)
  end
end