Spree::Admin::ProductsController.class_eval do
  def toggle_customizable
    @product = Spree::Product.find_by_permalink(params[:id])
    @product.toggle_customizable

    if @product.save
      flash[:succedd] = "Product set to " + (@product.is_customizable? ? "customizable." : "uncustomizable." )
    else
      flash[:error] = "Could not set product customizable."
    end

    respond_with(@product) do |format|
      format.html { redirect_to collection_url }
      format.js  { render_js_for_destroy }
    end
  end

end