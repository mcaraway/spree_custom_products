Deface::Override.new(:virtual_path => "spree/admin/products/index",
                     :name => "add_reprocess_images_button",
                     :insert_bottom => "ul.actions",
                     :text => "<li id='reporcess_product_images_link'><%= button_link_to t(:reprocess_images), spree.reprocess_images_admin_label_templates_url, :method => :post, :icon => 'icon-refresh', :id => 'reprocess_images_admin_label_templates_link' %></li>",
                     :original => '3e847740dc3e7fasda1ccb56645466676j734hskk')