class AddGuestToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :guest, :boolean
  end
end
