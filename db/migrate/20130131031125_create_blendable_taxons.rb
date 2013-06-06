class CreateBlendableTaxons < ActiveRecord::Migration
  def change
    create_table :spree_blendable_taxons do |t|
      t.integer :taxon_id

      t.timestamps
    end
    
    create_table :spree_blendable_products_taxons, :id => false, :force => true do |t|
      t.references :product
      t.references :blendable_taxon
    end

    add_index :spree_blendable_products_taxons, :product_id, :name => 'index_products_blendable_taxons_on_product_id'
    add_index :spree_blendable_products_taxons, :blendable_taxon_id, :name => 'index_products_blendable_taxons_on_taxon_id'
  end
  
  def down
    drop table :spree_blendable_taxons
    drop table :spree_blendable_products_taxons
    drop index :name => 'index_products_blendable_taxons_on_product_id'
    drop index :name => 'index_products_blendable_taxons_on_taxon_id'
  end
end
