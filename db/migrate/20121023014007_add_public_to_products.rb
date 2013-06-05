class AddPublicToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :public, :boolean, :default => true
    
    say_with_time 'Updating products count on hand' do
      Spree::Product.all.each do |p|
        p.update_column(:public, true)
      end
    end
  end
  
  def down
    drop_column :spree_products, :public
  end
end
