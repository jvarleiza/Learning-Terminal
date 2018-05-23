class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.datetime :start
      t.datetime :end
      t.string :name
      t.text :description
      t.integer :type
      t.string :color

      t.timestamps
    end
  end
end
