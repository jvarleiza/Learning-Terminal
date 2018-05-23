require 'rails_helper'

RSpec.describe "quality_tips/index", type: :view do
  before(:each) do
    assign(:quality_tips, [
      QualityTip.create!(
        :name => "Name",
        :description => "MyText"
      ),
      QualityTip.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of quality_tips" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
