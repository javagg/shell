class UserYcRole < ActiveRecord::Base
  set_table_name 'users_yc_roles'
  belongs_to :yc_role
  belongs_to :user
end