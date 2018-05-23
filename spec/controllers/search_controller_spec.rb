require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #search_results" do
    it "returns http success" do
      get :search_results
      expect(response).to have_http_status(:success)
    end
  end

end
