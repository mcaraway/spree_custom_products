class AddStepToSpreeCustomProducts < ActiveRecord::Migration
  def change
    add_column :spree_custom_products, :step, :string
  end
  
  def down
    remove_column :spree_custom_products, :step
  end
end
