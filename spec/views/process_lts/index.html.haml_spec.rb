require 'rails_helper'

RSpec.describe "process_lts/index", type: :view do
  before(:each) do
    assign(:process_lts, [
      ProcessLt.create!(
        :name => "Name",
        :description => "MyText"
      ),
      ProcessLt.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of process_lts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
