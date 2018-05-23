class CreateBookmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :bookmarks do |t|
      t.string :user
      t.string :roles
      t.string :processes
      t.string :tasks

      t.timestamps
    end
  end
end
