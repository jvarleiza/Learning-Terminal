require 'spec_helper'

describe ErrorsController, type: :controller do
  it 'should render a 404' do
    get :routing, params: { a: 'some/fake/path' }
    expect(response.status).to eq(404)
    expect(response).to render_template(file: Rails.root.join('public', '404.html').to_s)
  end

  it 'should log a FATAL if a redirect from within 404s' do
    expect(Rails.logger).to receive(:fatal)
    request.env['HTTP_REFERER'] = request.host
    get :routing, params: { a: 'some/fake/path' }
  end
end
