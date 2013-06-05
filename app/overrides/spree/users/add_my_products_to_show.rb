Deface::Override.new(:virtual_path => "spree/users/show",
                     :name => "add_my_products_20120918",
                     :replace => "[data-hook='account_summary'], #account_summary[data-hook]",
                     :partial => "spree/users/my_products")
