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

ActiveRecord::Schema.define(:version => 20101106124054) do

  create_table "archives", :force => true do |t|
    t.string   "number"
    t.string   "name"
    t.text     "description"
    t.string   "archive_type"
    t.string   "issue_dep"
    t.string   "keep_dep"
    t.string   "keeper"
    t.string   "origin_loc"
    t.date     "expired_at"
    t.string   "state"
    t.boolean  "has_backup"
    t.string   "backup_loc"
    t.boolean  "has_electrical_edtion"
    t.string   "security_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "width"
    t.integer  "height"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "index_attachments_on_attachable_id_and_attachable_type"

  create_table "contracts", :force => true do |t|
    t.string   "contract_type"
    t.string   "other_party"
    t.text     "content"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "expense_paid"
    t.string   "owning_department"
    t.integer  "amount",            :limit => 10, :precision => 10, :scale => 0
    t.string   "person_in_charge"
    t.string   "executive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documentables", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "number"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["name"], :name => "index_documents_on_name"

  create_table "licenses", :force => true do |t|
    t.integer  "sequence"
    t.string   "area"
    t.string   "station_name"
    t.string   "license_type"
    t.string   "issuing_authority"
    t.date     "issuing_date"
    t.date     "annual_inspection_date"
    t.date     "expired_on"
    t.string   "filing_location"
    t.text     "memo"
    t.string   "owning_department"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.date     "pay_date"
    t.integer  "amount",     :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username",                               :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "salt",                                   :null => false
    t.boolean  "active",              :default => false, :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
