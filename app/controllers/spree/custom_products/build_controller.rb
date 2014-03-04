class Spree::CustomProducts::BuildController < Spree::StoreController
  include Wicked::Wizard
  steps :pick_flavors, :add_name, :finalize
  ssl_required :only => [:customize, :new, :edit]

  before_filter :verify_login?
  before_filter :check_custom_product
  def update
    puts "****** in update"
    case step
    when :add_name
      image_params = params[:custom_product]
      if image_params[:image] != nil
        @image.assign_attributes(image_params.require(:image).permit!)
        @image.save!
        params[:custom_product].delete :image
      end
      params[:final] = true
    end
    @custom_product.update_attributes(params.require(:custom_product).permit!)

    if @custom_product.permalink.to_i > 0 && step == :add_name
      @custom_product.save_permalink(@custom_product.name.to_s.to_url)
      process_resource!(@custom_product)
      flash[:success] = t(:blend_is_final)
      redirect_to wizard_path(:finalize, :custom_product_id => @custom_product.permalink)
    else
      render_wizard @custom_product
    end
  end

  def new
    redirect_to wizard_path(steps.first, :custom_product_id => @custom_product.permalink)
  end

  def edit
    render_wizard
  end

  # GET /spree/custom_products/1
  def show
    puts "****** show"
    case step
    when :pick_flavors
      load_blendables
    end
    render_wizard
  end

  def create
    redirect_to wizard_path(steps.first, :custom_product_id => @custom_product.permalink)
  end

  def finish_wizard_path
    custom_product_path(:id => @custom_product.permalink)
  end

  protected

  def check_custom_product
    @custom_product = Spree::CustomProduct.find_by_permalink!(params[:custom_product_id])
    @image = @custom_product.image == nil ? @custom_product.build_image : Spree::Image.find(@custom_product.image.id)
  end

  def create_starter_product
    custom_product = Spree::CustomProduct.new
    custom_product.public = true
    custom_product.final = false
    custom_product.user_id = try_spree_current_user.id
    custom_product
  end

  private

  def check_authorization
    puts "****** checking auth"
    authorize! :create, Spree::CustomProduct
  end

  def verify_login?
    return if try_spree_current_user != nil
    session['spree_user_return_to'] = request.original_url
    redirect_to spree_login_path
  end

  def load_blendables
    @blendables = Spree::BlendableTaxon.all
    @black_teas = Spree::BlendableTaxon.find_by_name("Black Tea")
    @fruit_teas = Spree::BlendableTaxon.find_by_name("Fruit Tea")
    @herbal_teas = Spree::BlendableTaxon.find_by_name("Herbal Tea")
    @green_teas = Spree::BlendableTaxon.find_by_name("Green Tea")
    @white_teas = Spree::BlendableTaxon.find_by_name("White Tea")
  end

  # Only allow a trusted parameter "white list" through.
  def spree_custom_product_params
    params.require(:spree_custom_product).permit!
  end
end
