class AddEmbededVideoToProcessLts < ActiveRecord::Migration[5.0]
  def change
    add_column :process_lts, :embeded_video, :string
  end
end
