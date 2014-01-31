Deface::Override.new(:virtual_path => "spree/admin/configurations/index",
                     :name => "add_blendable_products_settings_link",
                     :insert_after => "[data-hook='admin_configurations_menu'], #admin_configurations_menu[data-hook]",
                     :text => "<tr>
<td><%= link_to \"Blendable Products\", edit_admin_blendable_products_settings_path %></td>
<td><%= \"Configure Blendable Product Settings\" %></td>
</tr>",
                     :original => '334898j740dc3e7f924aba1ccb566e9898f73734hskk')