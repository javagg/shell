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
      t.boolean :public, :default => false, :null => false
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
      t.string :name, :null => false, :uniq => true
      t.string :description
    end

    create_table :roles_users, :id => false, :force => true do |t|
      t.references :user, :null => false
      t.references :role, :null => false
    end
    
    create_table :documents, :force => true do |t|
      t.string :number
      t.string :name
      t.text :description
      
      t.references :user
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
      t.string :t5code
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
      t.string :confidential_level
      
      t.references :user
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
      t.boolean :has_backup, :default => false
      t.string :backup_loc
      t.boolean :has_electrical_edtion, :default => false
      t.string :confidential_level
      t.text :memo
      t.references :user
      t.timestamps
    end

    create_table :payments, :force => true do |t|
      t.references :contract
      t.date :pay_date
      t.decimal :amount
      t.boolean :has_deliverables, :default => false
      t.text :memo
      t.timestamps
    end
    
    create_table :payment_periods, :force => true do |t|
      t.references :contract
      t.date :first_payment_date
      t.date :start_date
      t.date :end_date
      t.integer :num_payments, :default => 1
    end

    create_table :expiration_remindings, :force => true do |t|
      t.references :reminder, :polymorphic => true
      t.references :user
      t.boolean :remindee_rejected, :default => false
    end

    create_table :payment_remindings, :force => true do |t|
      t.references :contract
      t.references :user
      t.boolean :remindee_rejected, :default => false
    end

    create_table :reminding_periods, :force => true do |t|
      t.references :reminder
      t.string :reminder_type
      t.date :start_date
      t.date :end_date
      t.integer :num_remindings, :default => 1
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
      t.date :expired_on
      t.string :state
      t.boolean :has_backup, :default => false
      t.string :backup_loc
      t.boolean :has_electrical_edtion, :default => false
      t.string :confidential_level

      t.references :user
      t.timestamps
    end

    create_table :settings, :force => true do |t|
      t.string :var, :null => false
      t.text :description
      t.string :value, :null => true
      t.timestamps
    end
    add_index :settings, :var, :uniq => true

    create_table :audits, :force => true do |t|
      t.column :auditable_id, :integer
      t.column :auditable_type, :string
      t.column :auditable_parent_id, :integer
      t.column :auditable_parent_type, :string
      t.column :user_id, :integer
      t.column :user_type, :string
      t.column :username, :string
      t.column :action, :string
      t.column :changes, :text
      t.column :version, :integer, :default => 0
      t.column :comment, :string
      t.column :created_at, :datetime
    end

    add_index :audits, [:auditable_id, :auditable_type], :name => 'auditable_index'
    add_index :audits, [:auditable_parent_id, :auditable_parent_type], :name => 'auditable_parent_index'
    add_index :audits, [:user_id, :user_type], :name => 'user_index'
    add_index :audits, :created_at

    create_table :ycroles, :force => true do |t|
      t.string :name, :uniq => true
      t.string :description
      t.string :type, :default => "public"
    end

    create_table :user_ycroles, :force => true do |t|
      t.references :user, :null => false
      t.references :ycrole, :null => false
    end

    create_table :permissions, :force => true do |t|
      t.references :ycrole
      t.references :manageable, :polymorphic => true
      t.boolean :can_read
      t.boolean :can_write
    end

    create_table :archive_permissions, :force => true do |t|
      t.references :ycrole
      t.references :archive
      t.boolean :can_read, :default => false
      t.boolean :can_write, :default => false
    end

    create_table :license_permissions, :force => true do |t|
      t.references :ycrole
      t.references :license
      t.boolean :can_read, :default => false
      t.boolean :can_write, :default => false
    end

    create_table :contract_permissions, :force => true do |t|
      t.references :ycrole
      t.references :contract
      t.boolean :can_read, :default => false
      t.boolean :can_write, :default => false
    end
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
    drop_table :expiration_remindings
    drop_table :payment_remindings
    drop_table :roles
    drop_table :roles_users
    drop_table :settings
    drop_table :payment_periods
    drop_table :reminding_periods
    drop_table :audits
    drop_table :ycroles
    drop_table :permissions
    drop_table :archive_permissions
    drop_table :license_permissions
    drop_table :contract_permissions
    drop_table :users_ycroles
  end
end
