class CreateRelatedProcesses < ActiveRecord::Migration[5.0]
  def change
    create_table "related_processes", id: false do |t|
      t.integer "process_lt_a_id"
      t.integer "process_lt_b_id"
    end
  end
end
