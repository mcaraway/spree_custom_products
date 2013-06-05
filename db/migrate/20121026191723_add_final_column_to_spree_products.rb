class AddFinalColumnToSpreeProducts < ActiveRecord::Migration
 
  def change
    add_column :spree_products, :final, :boolean, :default => false
    
    say_with_time 'Updating products count on hand' do
      Spree::Product.all.each do |p|
        p.update_column(:final, true)
      end
    end
  end
  
  def down
    drop_column :spree_products, :final
  end
end
