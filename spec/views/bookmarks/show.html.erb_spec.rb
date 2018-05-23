require 'rails_helper'

RSpec.describe "bookmarks/show", type: :view do
  before(:each) do
    @bookmark = assign(:bookmark, Bookmark.create!(
      :user => "User",
      :roles => "Roles",
      :processes => "Processes",
      :tasks => "Tasks"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Roles/)
    expect(rendered).to match(/Processes/)
    expect(rendered).to match(/Tasks/)
  end
end
