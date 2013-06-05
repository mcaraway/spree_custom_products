Spree::ProductsController.class_eval do
  include SslRequirement
  before_filter :load_product_for_edit, :only => [:edit, :update, :customize]
  ssl_required(:customize, :new)

  #before_filter :verify_login?, :only => [:new, :customize]

  respond_to :html, :json, :js
  def index
    params[:ispublic] = true
    logger.debug "****** Prototype is #{params}"
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products

    respond_with(@products)
  end
  def edit
    if @product.is_custom? then
      @edit_blend = true
    end
  end

  def update
    @edit_blend = true
    if @product.update_attributes(params[:product])
      @product.update_viewables
      if @product.final == false
        flash[:success] = "Your draft blend is saved."
      else
        link = "<a href=\"#{url_for(@product)}\">order</a>"
        flash[:success] = "<h2>Your blend is good to go! Now go #{link} some.</h2>".html_safe
      end
      if @product.final
        redirect_to proc { product_url(@product) }
      else
        redirect_to proc { edit_product_url(@product) }
      end
    else
      @product.final = @product.final_was
      respond_with(@product)
    end
  end

  def customize
    if params[:id]
      logger.debug "************ customizing " + params[:id]
      @new_product = @product.create_customized_copy(true)
      @new_product.user = try_spree_current_user

      if @new_product.save
        redirect_to proc { edit_product_url(@new_product) }
      else
        flash[:error] = "Could not duplicate product."
        respond_with(@product)
      end
    else
      flash[:error] = "Could not find product."
      redirect_to proc { root_url }
    end

  end

  def load_product_for_edit
    @product = Spree::Product.find_by_permalink(params[:id])
  end

  def verify_login?
    if try_spree_current_user == nil
      store_location
      flash[:notice] = "Please login or create an account so we can save your unique blend."
      redirect_to spree_login_path
    end
  end
end