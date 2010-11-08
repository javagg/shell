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
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true

    create_table :documents do |t|
      t.string :number
      t.string :name
      t.text :description

#      t.string :documentable_type
#
#      # for thinking sphinx
#      t.boolean :delta, :default => true, :null => false

      t.timestamps
    end
    add_index :documents, :name

    #    create_table :attachments do |t|
    #      t.integer :document_id
    #      t.integer :parent_id
    #      t.string :filename
    #      t.string :content_type
    #      t.integer :size
    #      t.integer :width
    #      t.integer :height
    #      t.string :thumbnail
    #      t.timestamps
    #    end
    
    create_table :attachments do |t|
      t.integer :attachable_id
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

    create_table :licenses do |t|
      t.integer :sequence
      t.string :area
      t.string :station_name
#      t.string :name
#      t.string :number
      t.string :license_type
      t.string :issuing_authority
      t.date :issuing_date
      t.date :annual_inspection_date
      t.date :expired_on
      t.string :filing_location
      t.text :memo
      t.string :owning_department
      t.timestamps
    end

    create_table :contracts do |t|
      t.string :number
      t.string :name
      t.text :description
      t.string :contract_type
      t.string :other_party
      t.text :content
      t.date :start_date
      t.date :end_date
      t.string :expense_paid
      t.string :owning_department
      t.decimal :amount
      t.string :person_in_charge
      t.string :executive
      
      t.timestamps
    end

    create_table :payments do |t|
      t.integer :contract_id
      t.date :pay_date
      t.decimal :amount
      t.timestamps
    end

    create_table :reminders do |t|
      t.integer :contract_id
      t.datetime :when
      t.timestamps
    end
    
    create_table :archives do |t|
      t.string :number
      t.string :name
      t.text :description
      t.string :archive_type
      t.string :issue_dep
      t.string :keep_dep
      t.string :keeper
      t.string :origin_loc
      t.date :expired_at
      t.string :state
      t.boolean :has_backup
      t.string :backup_loc
      t.boolean :has_electrical_edtion
      t.string :security_level
      t.timestamps
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
    drop_table :reminders
  end
end
