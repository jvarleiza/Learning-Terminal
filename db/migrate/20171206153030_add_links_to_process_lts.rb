class AddLinksToProcessLts < ActiveRecord::Migration[5.0]
  def change
    add_column :process_lts, :related_links, :text
    add_column :process_lts, :related_attachments, :text
  end
end
