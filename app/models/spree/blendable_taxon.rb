class Spree::BlendableTaxon < ActiveRecord::Base
  attr_accessible :taxon_id, :name, :product_ids

  belongs_to :taxon
  has_and_belongs_to_many :products, :join_table => 'spree_blendable_products_taxons'
  
  def name
    taxon.name
  end

end
