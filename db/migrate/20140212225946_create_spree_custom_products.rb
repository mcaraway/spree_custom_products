class CreateSpreeCustomProducts < ActiveRecord::Migration
  def change
    create_table :spree_custom_products do |t|
      t.string :name
      t.string :permalink
      t.string :description
      t.string :flavor_1_name
      t.string :flavor_2_name
      t.string :flavor_3_name
      t.integer :flavor_1_percentage
      t.integer :flavor_2_percentage
      t.integer :flavor_3_percentage
      t.string :flavor_1_sku
      t.string :flavor_2_sku
      t.string :flavor_3_sku
      t.float :sweetness
      t.float :fruity
      t.float :nutty
      t.float :vegetal
      t.float :woody
      t.float :aroma
      t.float :spicy
      t.float :floral
      t.float :strength
      t.integer :user_id
      t.boolean :public
      t.boolean :final

      t.timestamps
    end
  end
end
