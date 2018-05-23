class AddLocaleToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :process_lts, :locale, :string
    add_column :roles, :locale, :string
    add_column :tasks, :locale, :string
    add_column :quality_tips, :locale, :string
  end
end
