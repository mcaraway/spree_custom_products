class AddCustomProductIdToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :custom_product_id, :integer
  end
  
  def down
    remove_column :spree_line_items, :custom_product_id
  end
end
