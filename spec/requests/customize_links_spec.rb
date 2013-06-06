require 'spec_helper'

describe "customize_links" do
  include_context "custom products"

  before(:each) do
    visit spree.root_path
    @product = create(:product, :name => "Public Product", :public => true)
    @product.save!
    
    @product2 = create(:product, :name => "Private Product", :public => false)
    @product2.save!
  end

  it "should not show private products" do
    visit spree.products_path
    page.should have_content("Public Product")
    page.should_not have_content("Private Product")
  end

  # describe 'success' do
    # stub_authorization!
# 
    # it "should create a new product" do
      # lambda do 
        # click_link "Ruby on Rails Ringer T-Shirt"
        # click_link 'Customize'
      # end.should change(Spree::Product, :count).by(1)
    # end
# 
    # it "should show edit page" do
      # visit spree.product_path(@product)
      # click_link 'Customize'
      # page.should have_selector('div#edit-product')
    # end
  # end
end
