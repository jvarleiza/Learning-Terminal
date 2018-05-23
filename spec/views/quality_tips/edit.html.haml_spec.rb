require 'rails_helper'

RSpec.describe "quality_tips/edit", type: :view do
  before(:each) do
    @quality_tip = assign(:quality_tip, QualityTip.create!(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit quality_tip form" do
    render

    assert_select "form[action=?][method=?]", quality_tip_path(@quality_tip), "post" do

      assert_select "input#quality_tip_name[name=?]", "quality_tip[name]"

      assert_select "textarea#quality_tip_description[name=?]", "quality_tip[description]"
    end
  end
end
