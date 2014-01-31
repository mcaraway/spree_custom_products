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
    end
  end

  def create_sub_job (product)
    if product.is_custom? and !product.images.empty?
      Delayed::Job.enqueue Spree::ImageJob.new(product.images[0].id)
    else
      Delayed::Job.enqueue Spree::ReprocessProductImageJob.new(product.id)
    end
  end
end