
Deface::Override.new(:virtual_path => "spree/admin/products/index",
                     :name => "add_set_customizable_action",
                     :insert_bottom => "[data-hook='admin_products_index_row_actions'], #admin_products_index_row_actions[data-hook]",
                     :partial => "spree/admin/products/customizable_action",
                     :original => '3e847740dc3e7fasda1cdsdfd466676j734hskk')