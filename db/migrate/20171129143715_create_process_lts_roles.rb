class CreateProcessLtsRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :process_lts_roles, id: false do |t|
      t.references :process_lts, foreign_key: true
      t.references :role, foreign_key: true
    end
  end
end
