require 'spec_helper'

describe "customize_links" do

  before(:each) do
    @product = create(:product)
    visit spree.root_path
  end

  describe 'failure' do
  end

  describe 'success' do
    stub_authorization!

    it "should create a new product" do
      lambda do
        visit spree.customize_product_path(@product)
      end.should change(Spree::Product, :count).by(1)
    end

    it "should show edit page" do
      visit spree.product_path(@product)
      click_link 'Customize'
      page.should have_selector('div#edit-product')
    end
  end
end
