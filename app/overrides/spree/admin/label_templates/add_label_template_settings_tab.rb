Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "add_label_templates_settings_tab",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                     :text => "<li<%== ' class=\"active\"' if controller.controller_name == 'theme_settings' %>><%= link_to \"Label Templates\", admin_label_templates_path %></li>",
                     :original => '3e847740dc3e7f924aba1ccb56645466676j734hskk')