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

ActiveRecord::Schema.define(:version => 1) do

  create_table "archive_permissions", :force => true do |t|
    t.integer "ycrole_id"
    t.integer "archive_id"
    t.boolean "can_read",   :default => false
    t.boolean "can_write",  :default => false
  end

  create_table "archives", :force => true do |t|
    t.string   "number"
    t.string   "name"
    t.text     "description"
    t.string   "archive_type"
    t.string   "issue_dep"
    t.string   "keep_dep"
    t.string   "keeper"
    t.string   "original_loc"
    t.date     "expired_on"
    t.string   "state"
    t.boolean  "has_backup",            :default => false
    t.string   "backup_loc"
    t.boolean  "has_electrical_edtion", :default => false
    t.string   "confidential_level"
    t.integer  "user_id"
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

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "auditable_parent_id"
    t.string   "auditable_parent_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",               :default => 0
    t.string   "comment"
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["auditable_parent_id", "auditable_parent_type"], :name => "auditable_parent_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "contract_permissions", :force => true do |t|
    t.integer "ycrole_id"
    t.integer "contract_id"
    t.boolean "can_read",    :default => false
    t.boolean "can_write",   :default => false
  end

  create_table "contracts", :force => true do |t|
    t.string   "number"
    t.string   "name"
    t.text     "description"
    t.string   "station_name"
    t.string   "stamp_tax_type"
    t.string   "contract_type"
    t.string   "project_address"
    t.string   "trading_mode"
    t.date     "land_certificate_application_deadline"
    t.date     "property_certificate_application_deadline"
    t.string   "other_party"
    t.text     "contract_content"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "expense_paid"
    t.string   "owning_department"
    t.integer  "amount",                                    :limit => 10, :precision => 10, :scale => 0
    t.string   "holder"
    t.string   "executive"
    t.boolean  "transferred",                                                                            :default => false
    t.string   "state"
    t.string   "original_loc"
    t.boolean  "has_backup",                                                                             :default => false
    t.string   "backup_loc"
    t.boolean  "has_electrical_edtion",                                                                  :default => false
    t.string   "confidential_level"
    t.text     "memo"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "number"
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["name"], :name => "index_documents_on_name"

  create_table "expiration_remindings", :force => true do |t|
    t.integer "reminder_id"
    t.string  "reminder_type"
    t.integer "user_id"
    t.boolean "remindee_rejected", :default => false
  end

  create_table "license_permissions", :force => true do |t|
    t.integer "ycrole_id"
    t.integer "license_id"
    t.boolean "can_read",   :default => false
    t.boolean "can_write",  :default => false
  end

  create_table "licenses", :force => true do |t|
    t.string   "number"
    t.string   "name"
    t.text     "description"
    t.string   "t5code"
    t.string   "area"
    t.string   "station_name"
    t.string   "issuing_authority"
    t.date     "issuing_date"
    t.string   "state"
    t.date     "annual_inspection_date"
    t.date     "expired_on"
    t.string   "original_loc"
    t.string   "backup_loc"
    t.text     "memo"
    t.string   "owning_department"
    t.boolean  "has_electrical_edtion",  :default => false
    t.string   "confidential_level"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_periods", :force => true do |t|
    t.integer "contract_id"
    t.date    "first_payment_date"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "num_payments",       :default => 1
  end

  create_table "payment_remindings", :force => true do |t|
    t.integer "contract_id"
    t.integer "user_id"
    t.boolean "remindee_rejected", :default => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "contract_id"
    t.date     "pay_date"
    t.integer  "amount",           :limit => 10, :precision => 10, :scale => 0
    t.boolean  "has_deliverables",                                              :default => false
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer "ycrole_id"
    t.integer "manageable_id"
    t.string  "manageable_type"
    t.boolean "can_read"
    t.boolean "can_write"
  end

  create_table "reminding_periods", :force => true do |t|
    t.integer "reminder_id"
    t.string  "reminder_type"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "num_remindings", :default => 1
  end

  create_table "roles", :force => true do |t|
    t.string "name",        :null => false
    t.string "description"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "var",         :null => false
    t.text     "description"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["var"], :name => "index_settings_on_var"

  create_table "user_ycroles", :force => true do |t|
    t.integer "user_id",   :null => false
    t.integer "ycrole_id", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                               :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "salt",                                   :null => false
    t.boolean  "public",              :default => false, :null => false
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

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "ycroles", :force => true do |t|
    t.string "name"
    t.string "description"
    t.string "type",        :default => "public"
  end

end
