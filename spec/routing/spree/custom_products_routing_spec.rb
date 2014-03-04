require "spec_helper"

describe Spree::CustomProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/spree/custom_products").should route_to("spree/custom_products#index")
    end

    it "routes to #new" do
      get("/spree/custom_products/new").should route_to("spree/custom_products#new")
    end

    it "routes to #show" do
      get("/spree/custom_products/1").should route_to("spree/custom_products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/spree/custom_products/1/edit").should route_to("spree/custom_products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/spree/custom_products").should route_to("spree/custom_products#create")
    end

    it "routes to #update" do
      put("/spree/custom_products/1").should route_to("spree/custom_products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/spree/custom_products/1").should route_to("spree/custom_products#destroy", :id => "1")
    end

  end
end
