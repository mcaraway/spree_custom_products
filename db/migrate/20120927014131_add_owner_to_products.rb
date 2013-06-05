class AddOwnerToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :user_id, :integer
  end
  
  def down
    drop_column :spree_products, :user_id
  end
end