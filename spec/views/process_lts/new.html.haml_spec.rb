require 'rails_helper'

RSpec.describe "process_lts/new", type: :view do
  before(:each) do
    assign(:process_lt, ProcessLt.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new process_lt form" do
    render

    assert_select "form[action=?][method=?]", process_lts_path, "post" do

      assert_select "input#process_lt_name[name=?]", "process_lt[name]"

      assert_select "textarea#process_lt_description[name=?]", "process_lt[description]"
    end
  end
end
