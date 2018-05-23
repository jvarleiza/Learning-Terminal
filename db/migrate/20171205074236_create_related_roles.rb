class CreateRelatedRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :related_roles, id: false do |t|
      t.integer :role_a_id
      t.integer :role_b_id
    end
  end
end
