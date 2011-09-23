class AddArchivedToWords < ActiveRecord::Migration
  def change
    add_column :words, :archived, :boolean, :null => false, :default => false
  end
end
