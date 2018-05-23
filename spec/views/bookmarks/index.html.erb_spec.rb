require 'rails_helper'

RSpec.describe "bookmarks/index", type: :view do
  before(:each) do
    assign(:bookmarks, [
      Bookmark.create!(
        :user => "User",
        :roles => "Roles",
        :processes => "Processes",
        :tasks => "Tasks"
      ),
      Bookmark.create!(
        :user => "User",
        :roles => "Roles",
        :processes => "Processes",
        :tasks => "Tasks"
      )
    ])
  end

  it "renders a list of bookmarks" do
    render
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Roles".to_s, :count => 2
    assert_select "tr>td", :text => "Processes".to_s, :count => 2
    assert_select "tr>td", :text => "Tasks".to_s, :count => 2
  end
end
