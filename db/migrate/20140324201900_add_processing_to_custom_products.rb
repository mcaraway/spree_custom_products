class AddProcessingToCustomProducts < ActiveRecord::Migration
  def change
    add_column :spree_custom_products, :processing, :boolean
  end
  
  def down
    remove_colum :spree_custom_products, :processing
  end
end