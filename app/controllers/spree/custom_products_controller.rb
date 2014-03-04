class Spree::CustomProductsController < Spree::StoreController
  include Spree::Core::ControllerHelpers::Order
  before_filter :load_product, :only => [:show, :edit]
  before_filter :verify_login?, :only => [:new, :edit, :customize]
  # GET /spree/custom_products
  def index
    @custom_products = Spree::CustomProduct.all
  end

  def new
    @custom_product = create_starter_product
    @custom_product.save!

    redirect_to new_custom_product_build_url(:custom_product_id => @custom_product.permalink)
  end

  def edit
    redirect_to custom_product_build_path(:id=> "add_name", :custom_product_id => @custom_product.permalink)
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
    if try_spree_current_user == nil
      @user = Spree::User.create_guest_user
      if @user.save
        sign_in(:spree_user, @user)
        session[:spree_user_signup] = true
        associate_user
      else
        flash[:error] = "Unable to create guest account."
        redirect_to :back
      end
    end
  end

  private

  def load_product
    @custom_product = Spree::CustomProduct.find_by_permalink!(params[:id])
    @product = Spree::Product.find_by_permalink!("custom-product")
  end
end
