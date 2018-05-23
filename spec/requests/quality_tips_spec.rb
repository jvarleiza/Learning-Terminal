require 'rails_helper'

RSpec.describe "QualityTips", type: :request do
  describe "GET /quality_tips" do
    it "works! (now write some real specs)" do
      get quality_tips_path
      expect(response).to have_http_status(200)
    end
  end
end
