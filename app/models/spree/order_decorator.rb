module Spree
  Order.class_eval do
    def add_variant(variant, quantity = 1, custom_product = nil)
      current_item = contains?(variant, custom_product)
      if current_item
        current_item.quantity += quantity
        current_item.save
      else
        current_item = LineItem.new(:quantity => quantity)
        current_item.variant = variant

        current_item.custom_product = custom_product

        current_item.price = variant.price
        self.line_items << current_item
      end
      current_item
    end

    def contains?(variant, custom_product)
      find_line_item_by_variant(variant, custom_product).present?
    end

    def find_line_item_by_variant(variant, custom_product)
      line_items.detect do |li|
        li.variant_id == variant.id &&
          matching_custom_product(li.custom_product,custom_product)
      end
    end

    def merge!(order, user = nil)
      order.line_items.each do |line_item|
        self.add_variant(line_item.variant, line_item.quantity, line_item.custom_product)
      end

      self.associate_user!(user) if !self.user && !user.blank?

      # So that the destroy doesn't take out line items which may have been re-assigned
      order.line_items.reload
      order.destroy
    end

    private

    def matching_custom_product(existing_custom_product,new_custom_product)

      # if there aren't any customizations, there's a 'match'
      return true if existing_custom_product.blank? && new_custom_product.blank?

      existing_custom_product.id == new_custom_product.id
    end
  end
end
