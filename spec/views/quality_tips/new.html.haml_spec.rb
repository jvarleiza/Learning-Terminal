require 'rails_helper'

RSpec.describe "quality_tips/new", type: :view do
  before(:each) do
    assign(:quality_tip, QualityTip.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new quality_tip form" do
    render

    assert_select "form[action=?][method=?]", quality_tips_path, "post" do

      assert_select "input#quality_tip_name[name=?]", "quality_tip[name]"

      assert_select "textarea#quality_tip_description[name=?]", "quality_tip[description]"
    end
  end
end
