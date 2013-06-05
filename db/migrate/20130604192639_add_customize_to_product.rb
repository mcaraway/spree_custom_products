class AddCustomizeToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :customizable, :boolean, :default => false
    
    say_with_time 'Updating products customizable setting' do
      Spree::Product.all.each do |p|
        p.update_column(:customizable, false)
      end
    end
  end
  
  def down
    drop_column :spree_products, :customizable
  end
end
