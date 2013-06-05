require 'spec_helper'

describe Spree::Product do
  
  context "product copy" do
    before(:each) do
      @product = create(:product)
    end
    it "should create a new product" do
      lambda do
        copy = @product.create_customized_copy
        copy.save
      end.should change(Spree::Product, :count).by(1)
    end

    it "should generate a custom sku" do
      copy = @product.create_customized_copy

      copy.sku.include?(@product.sku+"-cust-").should be_true
    end
  end

  context "product has variants" do
    before(:each) do
      @product = create(:product)
      create(:variant, :product => @product)
      # reload so that we load the new variant
      @product = Spree::Product.find_by_id(@product.id)
    end

    it "should duplicate all variants" do

      lambda do
        copy = @product.create_customized_copy(true)
        @product.has_variants?.should be_true
        copy.has_variants?.should be_true
        copy.variants.size.should == @product.variants.size
      end.should change(Spree::Product, :count).by(@product.variants.size)

    end

    it "should create a custom sku for all variants" do
      copy = @product.create_customized_copy(true)
      @product.has_variants?.should be_true
      copy.has_variants?.should be_true
      copy.variants.each do  |variant|
        variant.sku.include?("-cust-").should be_true
      end
    end
  end
end