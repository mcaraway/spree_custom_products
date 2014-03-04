require 'spec_helper'

describe "spree/custom_products/edit" do
  before(:each) do
    @spree_custom_product = assign(:spree_custom_product, stub_model(Spree::CustomProduct,
      :name => "MyString",
      :description => "MyString",
      :flavor_1_name => "MyString",
      :flavor_2_name => "MyString",
      :flavor_3_name => "MyString",
      :flavor_1_percentage => 1.5,
      :flavor_2_percentage => 1.5,
      :flavor_3_percentage => 1.5,
      :flavor_1_sku => "MyString",
      :flavor_2_sku => "MyString",
      :flavor_3_sku => "MyString",
      :sweetness => 1,
      :fruity => 1,
      :nutty => 1,
      :vegetal => 1,
      :woody => 1,
      :aroma => 1,
      :spicy => 1,
      :floral => 1,
      :strength => 1
    ))
  end

  it "renders the edit spree_custom_product form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spree_custom_product_path(@spree_custom_product), "post" do
      assert_select "input#spree_custom_product_name[name=?]", "spree_custom_product[name]"
      assert_select "input#spree_custom_product_description[name=?]", "spree_custom_product[description]"
      assert_select "input#spree_custom_product_flavor_1_name[name=?]", "spree_custom_product[flavor_1_name]"
      assert_select "input#spree_custom_product_flavor_2_name[name=?]", "spree_custom_product[flavor_2_name]"
      assert_select "input#spree_custom_product_flavor_3_name[name=?]", "spree_custom_product[flavor_3_name]"
      assert_select "input#spree_custom_product_flavor_1_percentage[name=?]", "spree_custom_product[flavor_1_percentage]"
      assert_select "input#spree_custom_product_flavor_2_percentage[name=?]", "spree_custom_product[flavor_2_percentage]"
      assert_select "input#spree_custom_product_flavor_3_percentage[name=?]", "spree_custom_product[flavor_3_percentage]"
      assert_select "input#spree_custom_product_flavor_1_sku[name=?]", "spree_custom_product[flavor_1_sku]"
      assert_select "input#spree_custom_product_flavor_2_sku[name=?]", "spree_custom_product[flavor_2_sku]"
      assert_select "input#spree_custom_product_flavor_3_sku[name=?]", "spree_custom_product[flavor_3_sku]"
      assert_select "input#spree_custom_product_sweetness[name=?]", "spree_custom_product[sweetness]"
      assert_select "input#spree_custom_product_fruity[name=?]", "spree_custom_product[fruity]"
      assert_select "input#spree_custom_product_nutty[name=?]", "spree_custom_product[nutty]"
      assert_select "input#spree_custom_product_vegetal[name=?]", "spree_custom_product[vegetal]"
      assert_select "input#spree_custom_product_woody[name=?]", "spree_custom_product[woody]"
      assert_select "input#spree_custom_product_aroma[name=?]", "spree_custom_product[aroma]"
      assert_select "input#spree_custom_product_spicy[name=?]", "spree_custom_product[spicy]"
      assert_select "input#spree_custom_product_floral[name=?]", "spree_custom_product[floral]"
      assert_select "input#spree_custom_product_strength[name=?]", "spree_custom_product[strength]"
    end
  end
end
