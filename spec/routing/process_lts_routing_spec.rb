require "rails_helper"

RSpec.describe ProcessLtsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/process_lts").to route_to("process_lts#index")
    end

    it "routes to #new" do
      expect(:get => "/process_lts/new").to route_to("process_lts#new")
    end

    it "routes to #show" do
      expect(:get => "/process_lts/1").to route_to("process_lts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/process_lts/1/edit").to route_to("process_lts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/process_lts").to route_to("process_lts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/process_lts/1").to route_to("process_lts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/process_lts/1").to route_to("process_lts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/process_lts/1").to route_to("process_lts#destroy", :id => "1")
    end

  end
end
