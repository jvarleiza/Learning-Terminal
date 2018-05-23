class AddRestrictedToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :restricted, :boolean
    add_column :process_lts, :restricted, :boolean
    add_column :tasks, :restricted, :boolean
  end
end
