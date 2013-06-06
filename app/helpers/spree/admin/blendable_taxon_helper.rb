module Spree
  module Admin
    module BlendableTaxonHelper
      def blendable_taxon_products_for(blendable_taxon)
        
        options = @products.map do |product|
          selected = blendable_taxon.products.include?(product)
          content_tag(:option,
                      :value => product.id,
                      :selected => ('selected' if selected)) do
            product.name
          end
        end.join("").html_safe
      end
    end
  end
end