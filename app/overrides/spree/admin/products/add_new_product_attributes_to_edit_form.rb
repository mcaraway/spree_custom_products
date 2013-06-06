
Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "add_new_product_attributes_to_edit_form",
                     :insert_bottom => "[data-hook='admin_product_form_right'], #admin_product_form_right[data-hook]",
                     :partial => "spree/admin/products/new_attributes",
                     :original => '3e847740dc3edfdfsda1cdsdfd466676j734hskk')