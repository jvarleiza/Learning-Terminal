class AddContentToProcess < ActiveRecord::Migration[5.0]
  def change
    add_column :process_lts, :content, :text
  end
end
