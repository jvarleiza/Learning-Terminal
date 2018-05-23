class CreateProcessLts < ActiveRecord::Migration[5.0]
  def change
    create_table :process_lts do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
