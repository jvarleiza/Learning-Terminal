require 'rails_helper'

RSpec.describe "quality_tips/show", type: :view do
  before(:each) do
    @quality_tip = assign(:quality_tip, QualityTip.create!(
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
