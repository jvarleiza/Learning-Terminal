require 'rails_helper'

RSpec.describe "bookmarks/new", type: :view do
  before(:each) do
    assign(:bookmark, Bookmark.new(
      :user => "MyString",
      :roles => "MyString",
      :processes => "MyString",
      :tasks => "MyString"
    ))
  end

  it "renders new bookmark form" do
    render

    assert_select "form[action=?][method=?]", bookmarks_path, "post" do

      assert_select "input#bookmark_user[name=?]", "bookmark[user]"

      assert_select "input#bookmark_roles[name=?]", "bookmark[roles]"

      assert_select "input#bookmark_processes[name=?]", "bookmark[processes]"

      assert_select "input#bookmark_tasks[name=?]", "bookmark[tasks]"
    end
  end
end
