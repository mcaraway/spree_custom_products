# This migration comes from spree (originally 20121126040517)
class AddNameToBlendableTaxons < ActiveRecord::Migration
  def change
    add_column :spree_blendable_taxons, :name, :string
    
    say_with_time 'Updating blendable_Taxons with name' do
      Spree::BlendableTaxon.all.each do |p|
        p.update_column(:name, p.taxon.name)
      end
    end
  end
  
  def down
    remove_column :spree_blendable_taxons, :name
  end
end
