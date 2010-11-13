class Setup < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end
    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    create_table :users, :force => true do |t|
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :salt, :null => false
      t.boolean :active, :default => false, :null => false
      t.string :persistence_token, :null => false
      t.string :single_access_token, :null => false
      t.string :perishable_token, :null => false

      # Magic columns, just like ActiveRecord's created_at and updated_at.
      # These are automatically maintained by Authlogic if they are present.
      t.integer :login_count, :null => false, :default => 0
      t.integer :failed_login_count, :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip

      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email

    create_table :roles, :force => true do |t|
      t.string :name, :null => false
    end

    create_table :roles_users, :id => false do |t|
      t.references :user, :null => false
      t.references :role, :null => false
    end
    create_table :documents, :force => true do |t|
      t.string :number
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :documents, :name

    create_table :attachments, :force => true do |t|
      t.references :attachable
      t.string :attachable_type
      t.string :data_file_name
      t.string :data_content_type
      t.integer :data_file_size
      t.integer :width
      t.integer :height
      t.string :thumbnail
      t.timestamps
    end
    add_index :attachments, [:attachable_id, :attachable_type]

    create_table :licenses, :force => true do |t|
      t.string :number
      t.string :name
      t.text :description
      t.integer :t5code
      t.string :area
      t.string :station_name
      t.string :issuing_authority
      t.date :issuing_date
      t.string :state
      t.date :annual_inspection_date
      t.date :expired_on
      t.string :original_loc
      t.string :backup_loc
      t.text :memo
      t.string :owning_department
      t.boolean :has_electrical_edtion, :default => false
      t.string :security_level
      t.timestamps
    end

    create_table :contracts, :force => true do |t|
      t.string :number
      t.string :name
      t.text :description
      t.string :station_name
      t.string :stamp_tax_type
      t.string :contract_type
      t.string :project_address
      t.string :trading_mode
      t.date :land_certificate_application_deadline
      t.date :property_certificate_application_deadline
      t.string :other_party
      t.text :contract_content
      t.date :start_date
      t.date :end_date
      t.string :expense_paid
      t.string :owning_department
      t.decimal :amount
      t.string :holder
      t.string :executive
      t.boolean :transferred, :default => false
      t.string :state
      t.string :original_loc
      t.boolean :has_backup
      t.string :backup_loc
      t.boolean :has_electrical_edtion, :default => false
      t.string :security_level
      t.text :memo
      
      t.timestamps
    end

    create_table :payments, :force => true do |t|
      t.references :contract
      t.date :pay_date
      t.decimal :amount
      t.timestamps
    end

    create_table :reminders, :force => true do |t|
      t.references :contract
      t.datetime :when
      t.timestamps
    end
    
    create_table :archives, :force => true do |t|
      t.string :number
      t.string :name
      t.text :description
      t.string :archive_type
      t.string :issue_dep
      t.string :keep_dep
      t.string :keeper
      t.string :original_loc
      t.date :expired_at
      t.string :state
      t.boolean :has_backup, :default => false
      t.string :backup_loc
      t.boolean :has_electrical_edtion, :default => false
      t.string :security_level
      t.timestamps
    end

    create_table :settings, :force => true do |t|
      t.string :var, :null => false
      t.text :description
      t.text   :value, :null => true
      t.timestamps
    end
    add_index :settings, :var, :uniq => true
    
  end
  def self.down
    drop_table :sessions

    drop_table :users
    drop_table :documents
    drop_table :attachments
    drop_table :archives
    drop_table :licenses
    drop_table :contracts
    drop_table :payments
    drop_table :reminders
    drop_table :roles
    drop_table :roles_users
    drop_table :settings
  end
end
