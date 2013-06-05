Spree::UsersController.class_eval do
  before_filter :load_myblends, :only => [:show, :myblends]
  
  def load_myblends
    @user ||= try_spree_current_user
    logger.debug "*** user  #{@user.email}"
    @myblends = Kaminari.paginate_array(@user.myproducts).page(params[:page]).per(Spree::Config.products_per_page) 
  end
  
  def myblends
  end
end