Deface::Override.new(:virtual_path => "spree/taxons/show",
                     :name => "add_blend_it_20130117",
                     :insert_before => "[data-hook='taxon_products'], #taxon_products[data-hook]",
                     :partial => "spree/products/gallery_header")