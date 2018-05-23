class AddOriginToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :origin, :string
    add_column :process_lts, :origin, :string
    add_column :tasks, :origin, :string
  end
end
