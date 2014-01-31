Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "add_blendable_products_settings_tab",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                     :text => "<li<%== ' class=\"active\"' if controller.controller_name == 'theme_settings' %>><%= link_to \"Blendable Products\", admin_blendable_taxons_path %></li>",
                     :original => '3e847740dc3e7f924aba1ccb566e989498dhdj734hskk')