class AddLearningToWords < ActiveRecord::Migration
  def change
    add_column :words, :learning, :boolean, :null => false, :default => false
  end
end
