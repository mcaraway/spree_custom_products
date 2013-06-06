require 'spec_helper'

describe Spree::ProductsController do

  before(:each) do
    @product = create(:product)
    visit spree.root_path
  end

  describe 'success' do

    it "should create a new product" do
      lambda do
        visit spree.customize_product_path(@product)
      end.should change(Spree::Product, :count).by(1)
    end

    it "should show edit page" do
      visit spree.customize_product_path(@product)
      response.should render_template(:edit)
    end
  end
end
