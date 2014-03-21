module Spree::CustomProductsHelper
  def find_custom_products
    Spree::CustomProduct.where('(name ILIKE \'%'+params[:keywords]+'%\' OR description ILIKE \'%'+params[:keywords]+'%\') and public = true and final = true')
  end
end
