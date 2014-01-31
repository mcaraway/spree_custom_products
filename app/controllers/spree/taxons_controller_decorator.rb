Spree::TaxonsController.class_eval do
  def show
    @taxon = Spree::Taxon.find_by_permalink!(params[:id])
    return unless @taxon
    params[:ispublic] = true
    params[:iscustom] = params[:iscustom] == nil ? "false" : params[:iscustom]
    params[:iscustom] = params[:id] == "categories/custom-blend" ? true : params[:iscustom]
    logger.debug "****** Prototype is #{params}"

    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products

    respond_with(@taxon)
  end
end