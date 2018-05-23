class AddInactiveToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :process_lts, :inactive, :boolean
    add_column :roles, :inactive, :boolean
    add_column :tasks, :inactive, :boolean
    add_column :quality_tips, :inactive, :boolean
  end
end
