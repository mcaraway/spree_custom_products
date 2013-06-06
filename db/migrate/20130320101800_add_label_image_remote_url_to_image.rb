class AddLabelImageRemoteUrlToImage < ActiveRecord::Migration
  def change
    add_column :spree_assets, :label_image_remote_url, :string
  end
  
  def down
    drop_column :spree_assets, :label_image_remote_url
  end
end