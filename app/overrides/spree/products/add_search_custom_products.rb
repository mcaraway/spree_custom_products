Deface::Override.new(:virtual_path => "spree/products/index",
                     :name => "add_search_custom_products_20130117",
                     :insert_before => "[data-hook='search_results'], #search_results[data-hook]",
                     :partial => "spree/products/search_custom_products")