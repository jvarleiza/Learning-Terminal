require 'spec_helper'

describe PingController, type: :controller do
  it 'responds with status 200 to ping' do
    get :ping
    expect(response.status).to eq(200)
  end
end
