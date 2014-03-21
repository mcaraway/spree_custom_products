Spree::ProductsController.class_eval do
  include Spree::CustomProductsHelper
  
  before_filter :load_product_for_edit, :only => [:edit, :update, :customize]
  before_filter :create_custom_product, :only => :create
  before_filter :load_blendables, :only => [:new, :edit]
  before_filter :verify_login?, :only => [:new, :customize]
  ssl_required :only => [:customize, :new]

  respond_to :html, :json, :js
  def index
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
    @custom_products = (params[:keywords] != nil) ? find_custom_products : nil

    respond_with(@products)
  end

  def new
    @first_flavor = params[:flavor1]
    @prototype = Spree::Prototype.find_by_name("CustomTea")
    @product = Spree::Product.new(:price => 14.95 )
    @product.public = true
    @flavor_count = 3
    @product.shipping_category = Spree::ShippingCategory.first
    logger.debug "****** Prototype is #{@prototype.properties}"

    positions = Hash["flavor1name" => 0, "flavor2name" => 1, "flavor3name" => 2,
    "flavor1percent" => 3, "flavor2percent" => 4, "flavor3percent" => 5,
    "flavor1sku" => 6, "flavor2sku" => 7, "flavor3sku" => 8]
    @prototype.properties.each do |property|
      logger.debug "****** setting property  #{property}"
      @product.product_properties.build( :property_name => property.name, :position => positions[property.name] )
    end

    logger.debug "****** custom_product properties are now #{@product.product_properties}"
  end

  def edit
    if @product.is_custom? then
      @edit_blend = true
      if try_spree_current_user == nil or (try_spree_current_user != nil and try_spree_current_user.id != @product.user.id) then
        render @product
      end
    end
  end

  def create
    logger.debug "****** custom_product name is #{@product.name}"
    @product.user = try_spree_current_user
    @product.sku = get_custom_sku
    @product.shipping_category = Spree::ShippingCategory.find_by_name("Default Shipping")
    @product.tax_category= Spree::TaxCategory.find_by_name("Food")
    @product.weight = 0.5
    @product.height = 6
    @product.width = 2.6
    @product.depth = 2.6
    @product.price = 12.95
    @product.available_on = Time.now.getutc
    @product.final = false
    @product.public = params[:product][:public]
    @product.stock_items.build()
    #@product.on_hand = 999999
    @product.meta_keywords = Spree.t(:custom_blend_meta_keywords)
    @product.meta_description = Spree.t(:custom_blend_meta_description)

    main_taxonomy = Spree::Taxonomy.where("name='Categories'"+ (current_store ? " and store_id=" + current_store.id.to_s : ""))
    @custom_tea_taxon = Spree::Taxon.where("permalink like '%custom-blend'" + (main_taxonomy ? " and taxonomy_id=" + main_taxonomy.first.id.to_s : ""));
    @product.taxons = [@custom_tea_taxon.first] if @custom_tea_taxon

    if @product.save
      @product.update_viewables
      create_default_image
      flash[:success] = "Your draft blend is saved.  Now add some art and click Finalize to be able to order it."
      redirect_to proc { edit_product_url(@product) }
    else
      load_blendables
      render :new
    end
  end

  def create_default_image
    url = "#{Rails.root}/public/images/templates/your-image-here.jpg"
    logger.debug("************** url = " + url)
    image = Spree::Image.new
    image.viewable_type = 'Spree::Variant'
    image.alt = @product.name
    image.viewable_id = @product.master.id
    image.attachment = File.open(url)
    image.save!
  end

  def setup_volume_pricing
    create_volume_price("Low","1..19",12.95,1,@product.master)
    create_volume_price("Med","20..49",11.65,2,@product.master)
    create_volume_price("High","50..99",10.50,3,@product.master)
    create_volume_price("X High","100..199",9.45,4,@product.master)
    create_volume_price("XX High","200+",8.50,5,@product.master)
  end

  def create_volume_price (name, range, amount, position, variant)
    volume = Spree::VolumePrice.new
    volume.name = name
    volume.range = range
    volume.amount = amount
    volume.position = position
    volume.variant_id = variant.id
    volume.discount_type = "price"
    volume.save
  end

  def update
    @edit_blend = true
    if @product.update_attributes(params[:product])
      @product.update_viewables

      if try_spree_current_user.guest?
        flash[:success] = "Your blend is ready.  Just create an account so we can order your unique blend."
      elsif @product.final == false
        flash[:success] = "Your draft blend is saved."
      else
        link = "<a href=\"#{url_for(@product)}\">order</a>"
        flash[:success] = "<h2>Your blend is good to go! Now go #{link} some.</h2>".html_safe
      end
      logger.debug "******* try_spree_current_user.guest? = " + try_spree_current_user.guest?.to_s
      if try_spree_current_user.guest?
        remember_guest_product
        store_return_to(product_url(@product))
        redirect_to proc { signup_url }
      elsif @product.final
        redirect_to proc { product_url(@product) }
      else
        redirect_to proc { edit_product_url(@product) }
      end
    else
      load_blendables
      @product.final = @product.final_was
      respond_with(@product)
    end
  end

  def remember_guest_product
    if try_spree_current_user.guest?
      session['guest_product'] = @product.id.to_s
      sign_out(try_spree_current_user)
      flash[:warning] = "If you cancel now you will lose your blend."
    end
  end

  def show
    return unless @product

    @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
    @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)

    referer = request.env['HTTP_REFERER']
    if referer
      referer_path = URI.parse(request.env['HTTP_REFERER']).path
      if referer_path && referer_path.match(/\/t\/(.*)/)
        @taxon = Spree::Taxon.find_by_permalink($1)
      end
    end

    respond_with(@product)
  end

  def customize
    logger.debug "************ in customize"
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
      logger.debug "************ customizing Could not find product."
      flash[:error] = "Could not find product."
      redirect_to proc { root_url }
    end

  end

  def product_image(product, item_prop)
    image_tag(product.images.first, :item_prop => item_prop)
  end

  def redirect_back_or_default(default)
    redirect_to(session["user_return_to"] || default)
    session["user_return_to"] = nil
  end
  private

  def create_custom_product
    @product = Spree::Product.new(permit_attributes)
  end

  def get_custom_sku
    count = Spree::Variant.count_by_sql("select count(*) from spree_variants where sku like 'CUST%'")

    logger.debug "****** count Products with sku CUST% = #{count}"

    new_sku = "CUST_"+count.to_s().rjust(8, '0')

    new_sku
  end

  def load_product_for_edit
    debugger
    logger.debug "************ load_product_for_edit."
    if try_spree_current_user.try(:has_spree_role?, "admin")
      @product = Spree::Product.find_by_permalink!(params[:id])
    else
      @product = Spree::Product.active(current_currency).find_by_permalink!(params[:id])
    end
  end

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

  def load_blendables
    @blendables = Spree::BlendableTaxon.all
    @black_teas = Spree::BlendableTaxon.find_by_name("Black Tea")
    @fruit_teas = Spree::BlendableTaxon.find_by_name("Fruit Tea")
    @herbal_teas = Spree::BlendableTaxon.find_by_name("Herbal Tea")
    @green_teas = Spree::BlendableTaxon.find_by_name("Green Tea")
    @white_teas = Spree::BlendableTaxon.find_by_name("White Tea")
  end

  def permit_attributes
    params.require(:product).permit!
  end
end