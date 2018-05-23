require 'rails_helper'

RSpec.describe "bookmarks/edit", type: :view do
  before(:each) do
    @bookmark = assign(:bookmark, Bookmark.create!(
      :user => "MyString",
      :roles => "MyString",
      :processes => "MyString",
      :tasks => "MyString"
    ))
  end

  it "renders the edit bookmark form" do
    render

    assert_select "form[action=?][method=?]", bookmark_path(@bookmark), "post" do

      assert_select "input#bookmark_user[name=?]", "bookmark[user]"

      assert_select "input#bookmark_roles[name=?]", "bookmark[roles]"

      assert_select "input#bookmark_processes[name=?]", "bookmark[processes]"

      assert_select "input#bookmark_tasks[name=?]", "bookmark[tasks]"
    end
  end
end
