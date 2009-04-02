# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090402165522) do

  create_table "categories", :force => true do |t|
    t.integer "category_id"
    t.string  "name",                           :null => false
    t.text    "description",                    :null => false
    t.integer "companies_count", :default => 0, :null => false
  end

  create_table "companies", :force => true do |t|
    t.integer "category_id"
    t.string  "name",         :null => false
    t.string  "full_name",    :null => false
    t.integer "inn"
    t.string  "address"
    t.string  "site"
    t.string  "director"
    t.text    "description"
    t.string  "working_time"
    t.string  "sources"
  end

  create_table "emails", :force => true do |t|
    t.integer "company_id"
    t.string  "email",      :null => false
    t.string  "person"
    t.string  "department"
  end

  add_index "emails", ["email"], :name => "index_emails_on_email", :unique => true

  create_table "phones", :force => true do |t|
    t.integer "company_id"
    t.integer "number",       :null => false
    t.string  "person"
    t.string  "department"
    t.string  "working_time"
    t.string  "description"
  end

  add_index "phones", ["number"], :name => "index_phones_on_number", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name", :null => false
  end

end
