require 'spec_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  it 'should find a Midway authenticated user' do
    request.env['HTTP_X_FORWARDED_USER'] = 'fakeuser'
    get :index
    expect(assigns(:remote_user)).to eq('fakeuser')
  end

  it 'should find a local user without Midway authentication' do
    ENV['REMOTE_USER'] = 'fakename'
    get :index
    expect(assigns(:remote_user)).to eq('fakename')
  end
end
