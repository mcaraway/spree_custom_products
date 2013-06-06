class AddLabelImageToLabelTemplate < ActiveRecord::Migration
  def change
    add_column :spree_label_templates, :label_image_file_name, :string
    add_column :spree_label_templates, :label_image_content_type, :string
    add_column :spree_label_templates, :label_image_width, :integer
    add_column :spree_label_templates, :label_image_height, :integer
    add_column :spree_label_templates, :label_image_size, :integer
    add_column :spree_label_templates, :label_image_updated_at, :timestamp
  end
end