Deface::Override.new(:virtual_path => "spree/shared/_main_nav_bar",
                     :name => "add_blendit_link",
                     :insert_bottom => "#main-nav-bar",
                     :text => "<li id='blendit_link'><%= link_to \"blend a tea\", \"/blendit\" %></li>",
                     :original => '3e847740dc3e7dfgfhh456468dhdj734hskk')