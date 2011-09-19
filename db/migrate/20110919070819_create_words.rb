class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :russian
      t.string :english

      t.timestamps
    end
  end
end
