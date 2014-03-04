require 'spec_helper'

describe "spree/custom_products/show" do
  before(:each) do
    @spree_custom_product = assign(:spree_custom_product, stub_model(Spree::CustomProduct,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    rendered.should match(/Flavor 1 Name/)
    rendered.should match(/Flavor 2 Name/)
    rendered.should match(/Flavor 3 Name/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/Flavor 1 Sku/)
    rendered.should match(/Flavor 2 Sku/)
    rendered.should match(/Flavor 3 Sku/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
  end
end
