require 'rails_helper'

RSpec.describe "process_lts/edit", type: :view do
  before(:each) do
    @process_lt = assign(:process_lt, ProcessLt.create!(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit process_lt form" do
    render

    assert_select "form[action=?][method=?]", process_lt_path(@process_lt), "post" do

      assert_select "input#process_lt_name[name=?]", "process_lt[name]"

      assert_select "textarea#process_lt_description[name=?]", "process_lt[description]"
    end
  end
end
