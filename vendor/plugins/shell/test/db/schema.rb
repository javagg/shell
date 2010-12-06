ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.column :username, :string
  end
  
  create_table :roles, :force => true do |t|
    t.string :name
  end

  create_table :users_roles, :force => true do |t|
    t.references :user
    t.references :role
  end
  
  create_table :authorizables, :force => true do |t|
    t.string :name
    t.string :type
  end

  create_table :permissions, :force => true do |t|
    t.references :authorizable
    t.references :role
  end
  
end
