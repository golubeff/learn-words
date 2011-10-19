class AddArchivedAtToWords < ActiveRecord::Migration
  def change
    add_column :words, :archived_at, :datetime
    execute "update words set archived_at = now() where archived is true"
  end
end
