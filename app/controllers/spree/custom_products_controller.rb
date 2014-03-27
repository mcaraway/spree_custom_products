class Spree::CustomProductsController < Spree::StoreController
  include Spree::CustomProductsHelper
  helper 'spree/taxons'
  helper 'spree/products'
  before_filter :load_product, :only => [:show, :edit]
  before_filter :verify_login?, :only => [:new, :edit, :customize]
  # GET /spree/custom_products
  def index
    @custom_products = (params[:keywords] != nil) ? find_custom_products : Spree::CustomProduct.where('public = true and final = true')
    @taxon = Spree::Taxon.find_by_permalink('categories/custom-blend')
  end

  def new
    @custom_product = create_starter_product
    @custom_product.save!

    redirect_to new_custom_product_build_url(:custom_product_id => @custom_product.permalink)
  end

  def edit
    redirect_to custom_product_build_path(:id=> (@custom_product.permalink.to_i > 0 ? "pick_flavors" : "add_name" ), :custom_product_id => @custom_product.permalink)
  end

  protected
  
  def create_starter_product
    custom_product = Spree::CustomProduct.new
    custom_product.public = true
    custom_product.final = false
    custom_product.user_id = try_spree_current_user.id
    custom_product
  end

  private

  def verify_login?
    return if try_spree_current_user != nil
    session['spree_user_return_to'] = request.original_url
    redirect_to spree_login_path
  end

  def load_product
    @custom_product = Spree::CustomProduct.find_by_permalink!(params[:id])
    @product = Spree::Product.find_by_permalink!("custom-product")
  end
end
