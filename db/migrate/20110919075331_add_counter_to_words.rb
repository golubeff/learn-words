class AddCounterToWords < ActiveRecord::Migration
  def change
    add_column :words, :counter, :integer, :null => false, :default => 0
  end
end
