Spree::User.class_eval do
  #has_and_belongs_to_many :products, :class_name => "Spree::Product", :join_table => 'user_products', :foreign_key => 'user_id'
  has_many :custom_products
  
  def myproducts
    myproducts = []
    
    custom_products.each do |product|
      if product.deleted_at == nil
        myproducts << product
      end
    end
    myproducts
  end
  
  def self.create_guest_user
    new { |u| u.guest = true; 
      u.email = get_guest_email; 
      u.password = (0...8).map{(65+rand(26)).chr}.join;
      u.password_confirmation = u.password }
  end
  
  private
  
  def self.get_guest_email
    "guest"+ Spree::User.all.size.to_s+"@guest.com"
  end
end