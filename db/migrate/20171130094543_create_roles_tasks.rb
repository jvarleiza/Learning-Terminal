class CreateRolesTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :roles_tasks, id: false do |t|
      t.references :role, foreign_key: true
      t.references :task, foreign_key: true
    end
  end
end
