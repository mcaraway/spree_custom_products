Spree::UserSessionsController.class_eval do
  after_filter :move_products, :only => :create

  def move_products
    guest_product_id = session['guest_product']
    if guest_product_id 
      guest_product = Spree::Product.find_by_id(guest_product_id.to_i)
      
      guest_product.user_id = try_spree_current_user.id
      
      guest_product.save!
    end
  end
    
  def redirect_back_or_default(default)
    logger.debug "******** redirect_back_or_default location = " + (session["spree_user_return_to"] || default)
    redirect_to(session["spree_user_return_to"] || default)
    session["spree_user_return_to"] = nil
  end
end