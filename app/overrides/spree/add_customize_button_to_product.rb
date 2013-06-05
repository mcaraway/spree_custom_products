 Deface::Override.new(:virtual_path => "spree/products/show",
                    :name => "add_customize_button_to_product",
                    :insert_top => "[data-hook='product_right_part_wrap'], #product_right_part_wrap[data-hook]",
                    :partial => "spree/products/customize")
