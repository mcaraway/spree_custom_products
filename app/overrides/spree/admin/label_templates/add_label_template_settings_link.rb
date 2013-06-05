Deface::Override.new(:virtual_path => "spree/admin/configurations/index",
                     :name => "add_label_templates_settings_link",
                     :insert_after => "[data-hook='admin_configurations_menu'], #admin_configurations_menu[data-hook]",
                     :text => "<tr>
<td><%= link_to \"Label Templates\", edit_admin_label_templates_settings_path %></td>
<td><%= \"Configure Label Templates Settings\" %></td>
</tr>",
                     :original => '334898j740dc3e7f9245454cb566e9898f73734hskk')