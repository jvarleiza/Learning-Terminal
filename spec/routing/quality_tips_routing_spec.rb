require "rails_helper"

RSpec.describe QualityTipsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/quality_tips").to route_to("quality_tips#index")
    end

    it "routes to #new" do
      expect(:get => "/quality_tips/new").to route_to("quality_tips#new")
    end

    it "routes to #show" do
      expect(:get => "/quality_tips/1").to route_to("quality_tips#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/quality_tips/1/edit").to route_to("quality_tips#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/quality_tips").to route_to("quality_tips#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/quality_tips/1").to route_to("quality_tips#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/quality_tips/1").to route_to("quality_tips#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/quality_tips/1").to route_to("quality_tips#destroy", :id => "1")
    end

  end
end
