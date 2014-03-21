module Spree
  OrderContents.class_eval do
    # Get current line item for variant if exists
    # Add variant qty to line_item
    def add(variant, quantity = 1, currency = nil, shipment = nil, custom_product = nil)
      line_item = order.find_line_item_by_variant(variant, custom_product)
      add_to_line_item(line_item, variant, quantity, currency, shipment, custom_product)
    end

    private
      def add_to_line_item(line_item, variant, quantity, currency=nil, shipment=nil, custom_product = nil)
        if line_item
          line_item.target_shipment = shipment
          line_item.quantity += quantity.to_i
          line_item.currency = currency unless currency.nil?
        else
          line_item = order.line_items.new(quantity: quantity, variant: variant)
          line_item.target_shipment = shipment

          line_item.custom_product_id = custom_product.id

          if currency
            line_item.currency = currency unless currency.nil?
            line_item.price    = variant.price_in(currency).amount
          else
            line_item.price    = variant.price
          end
        end
  
        line_item.save
        order.reload

        line_item
      end
  
  end
end
