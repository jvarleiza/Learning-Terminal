require 'rails_helper'

RSpec.describe "ProcessLts", type: :request do
  describe "GET /process_lts" do
    it "works! (now write some real specs)" do
      get process_lts_path
      expect(response).to have_http_status(200)
    end
  end
end
