class Spree::Admin::BlendableTaxonsController < Spree::Admin::ResourceController
  respond_to :json, :only => [:get_children]
  before_filter :load_data, :except => :index
  
  def update
    if params[:blendable_taxon][:product_ids].present?
      params[:blendable_taxon][:product_ids].reject! { |c| c.empty? }
    end
    super
  end

  def get_children
    @products = Products.find(params[:id]).children

    respond_with(@products)
  end

  protected

  def load_data
    @products = Spree::Product.where("user_id is null").order(:name)
  end

  def location_after_save
    if @blendable_taxon.created_at == @blendable_taxon.updated_at
      edit_admin_blendable_taxon_url(@blendable_taxon)
    else
      edit_admin_blendable_taxon_url(@blendable_taxon)
    end
  end

  private
end