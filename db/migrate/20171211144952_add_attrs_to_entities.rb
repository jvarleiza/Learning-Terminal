class AddAttrsToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :process_lts, :departments, :string
    add_column :process_lts, :countries, :string
    add_column :process_lts, :building_types, :string
    
    add_column :roles, :departments, :string
    add_column :roles, :countries, :string
    add_column :roles, :building_types, :string
    
    add_column :tasks, :departments, :string
    add_column :tasks, :countries, :string
    add_column :tasks, :building_types, :string
    
    add_column :quality_tips, :departments, :string
    add_column :quality_tips, :countries, :string
    add_column :quality_tips, :building_types, :string
  end
end
