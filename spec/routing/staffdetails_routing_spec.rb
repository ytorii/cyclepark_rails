require "rails_helper"

RSpec.describe StaffdetailsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/staffdetails").to route_to("staffdetails#index")
    end

    it "routes to #new" do
      expect(:get => "/staffdetails/new").to route_to("staffdetails#new")
    end

    it "routes to #show" do
      expect(:get => "/staffdetails/1").to route_to("staffdetails#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/staffdetails/1/edit").to route_to("staffdetails#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/staffdetails").to route_to("staffdetails#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/staffdetails/1").to route_to("staffdetails#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/staffdetails/1").to route_to("staffdetails#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/staffdetails/1").to route_to("staffdetails#destroy", :id => "1")
    end

  end
end
