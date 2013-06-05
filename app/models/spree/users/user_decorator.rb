Spree::User.class_eval do
  #has_and_belongs_to_many :products, :class_name => "Spree::Product", :join_table => 'user_products', :foreign_key => 'user_id'
  has_many :products
  
  def myproducts
    myproducts = []
    
    products.each do |product|
      if product.deleted_at == nil
        myproducts << product
      end
    end
    myproducts
  end
end