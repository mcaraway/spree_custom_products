Deface::Override.new(:virtual_path => "spree/shared/_main_nav_bar",
                     :name => "add_gallery_link",
                     :insert_bottom => "#main-nav-bar",
                     :text => "<li id='gallery_link'><%= link_to \"user gallery\", \"/gallery\" %></li>",
                     :original => '3e847740dc3e7f924aba1cc456468dhdj734hskk')