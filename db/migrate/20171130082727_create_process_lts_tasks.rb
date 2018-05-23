class CreateProcessLtsTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :process_lts_tasks, id: false do |t|
      t.references :task, foreign_key: true
      t.references :process_lt, foreign_key: true
    end
  end
end
