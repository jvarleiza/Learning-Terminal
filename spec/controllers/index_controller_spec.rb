require 'spec_helper'

describe IndexController, type: :controller do
  it 'should render the index page' do
    get :index
    expect(response).to render_template('index')
  end
end
