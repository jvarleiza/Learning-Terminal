class CreateRelatedTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :related_tasks, id: false do |t|
      t.integer :task_a_id
      t.integer :task_b_id
    end
  end
end
