# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111013025632) do

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", :force => true do |t|
    t.string   "russian"
    t.string   "english"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "counter",         :default => 0,     :null => false
    t.integer  "initial_counter", :default => 0,     :null => false
    t.boolean  "archived",        :default => false, :null => false
    t.boolean  "learning",        :default => false, :null => false
    t.datetime "archived_at"
  end

end
