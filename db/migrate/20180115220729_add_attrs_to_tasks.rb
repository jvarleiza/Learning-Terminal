class AddAttrsToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :day_of_week, :integer
    add_column :tasks, :hour_start, :integer
    add_column :tasks, :min_start, :integer
    add_column :tasks, :duration, :integer
    add_column :tasks, :mark_start, :boolean
  end
end
