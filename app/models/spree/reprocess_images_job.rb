class Spree::ReprocessImagesJob < Struct.new(:image_id)
  def perform
    @products = Spree::Product.all

    @products.each do |product|
      if !product.deleted_at.nil?
      next
      end
      if (product.is_custom? or product.is_customized?) and !product.images.empty?
        Delayed::Job.enqueue Spree::ImageJob.new(product.images[0].id)
      else
        Delayed::Job.enqueue Spree::ReprocessProductImageJob.new(product.id)
      end
    end
  end
end