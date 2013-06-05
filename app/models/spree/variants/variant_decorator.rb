Spree::Variant.class_eval do
  include ActionView::Helpers::NumberHelper

  attr_accessible :option_values
  def to_hash
    actual_price = self.price
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    {
      :id => self.id,
      :count => self.count_on_hand,
      :price => number_to_currency(actual_price)
    }
  end

  def options_text
    values = self.option_values.joins(:option_type).order("#{Spree::OptionType.table_name}.position asc")

    values.map! do |ov|
      "#{ov.presentation}"
    end

    values.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
  end

  def is_custom?
    sku.include? custom_sku_indicator
  end

  def is_customized?
    sku.include? customized_sku_indicator
  end

  def customized_sku_indicator
    "-cust-"
  end

  def custom_sku_indicator
    "CUST-"
  end
end