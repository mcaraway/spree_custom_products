class AddImageToCustomProducts < ActiveRecord::Migration
  def change
    add_column :spree_custom_products, :label_image_file_name, :string
    add_column :spree_custom_products, :label_image_content_type, :string
    add_column :spree_custom_products, :label_image_width, :integer
    add_column :spree_custom_products, :label_image_height, :integer
    add_column :spree_custom_products, :label_image_size, :integer
    add_column :spree_custom_products, :label_image_updated_at, :timestamp
  end
  
  def down
    remove_colum :spree_custom_products, :label_image_file_name
    remove_colum :spree_custom_products, :label_image_content_type
    remove_colum :spree_custom_products, :label_image_width
    remove_colum :spree_custom_products, :label_image_height
    remove_colum :spree_custom_products, :label_image_size
    remove_colum :spree_custom_products, :label_image_updated_at
  end
end