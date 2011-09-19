class AddInitialCounterToWords < ActiveRecord::Migration
  def change
    add_column :words, :initial_counter, :integer, :null => false, :default => 0
  end
end
