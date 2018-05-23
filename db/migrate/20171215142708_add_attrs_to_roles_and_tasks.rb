class AddAttrsToRolesAndTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :related_links, :string
    add_column :roles, :related_attachments, :string
    
    add_column :tasks, :related_links, :string
    add_column :tasks, :related_attachments, :string
  end
end
