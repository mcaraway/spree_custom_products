require 'spec_helper'

describe "spree/custom_products/index" do
  before(:each) do
    assign(:spree_custom_products, [
      stub_model(Spree::CustomProduct,
        :name => "Name",
        :description => "Description",
        :flavor_1_name => "Flavor 1 Name",
        :flavor_2_name => "Flavor 2 Name",
        :flavor_3_name => "Flavor 3 Name",
        :flavor_1_percentage => 1.5,
        :flavor_2_percentage => 1.5,
        :flavor_3_percentage => 1.5,
        :flavor_1_sku => "Flavor 1 Sku",
        :flavor_2_sku => "Flavor 2 Sku",
        :flavor_3_sku => "Flavor 3 Sku",
        :sweetness => 1,
        :fruity => 2,
        :nutty => 3,
        :vegetal => 4,
        :woody => 5,
        :aroma => 6,
        :spicy => 7,
        :floral => 8,
        :strength => 9
      ),
      stub_model(Spree::CustomProduct,
        :name => "Name",
        :description => "Description",
        :flavor_1_name => "Flavor 1 Name",
        :flavor_2_name => "Flavor 2 Name",
        :flavor_3_name => "Flavor 3 Name",
        :flavor_1_percentage => 1.5,
        :flavor_2_percentage => 1.5,
        :flavor_3_percentage => 1.5,
        :flavor_1_sku => "Flavor 1 Sku",
        :flavor_2_sku => "Flavor 2 Sku",
        :flavor_3_sku => "Flavor 3 Sku",
        :sweetness => 1,
        :fruity => 2,
        :nutty => 3,
        :vegetal => 4,
        :woody => 5,
        :aroma => 6,
        :spicy => 7,
        :floral => 8,
        :strength => 9
      )
    ])
  end

  it "renders a list of spree/custom_products" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Flavor 1 Name".to_s, :count => 2
    assert_select "tr>td", :text => "Flavor 2 Name".to_s, :count => 2
    assert_select "tr>td", :text => "Flavor 3 Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Flavor 1 Sku".to_s, :count => 2
    assert_select "tr>td", :text => "Flavor 2 Sku".to_s, :count => 2
    assert_select "tr>td", :text => "Flavor 3 Sku".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
  end
end
