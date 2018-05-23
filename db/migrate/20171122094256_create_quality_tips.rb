class CreateQualityTips < ActiveRecord::Migration[5.0]
  def change
    create_table :quality_tips do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
