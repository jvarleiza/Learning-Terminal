require 'rails_helper'

RSpec.describe "process_lts/show", type: :view do
  before(:each) do
    @process_lt = assign(:process_lt, ProcessLt.create!(
      :name => "Name",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
