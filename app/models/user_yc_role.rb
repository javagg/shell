class UserYcRole < ActiveRecord::Base
  set_table_name 'users_yc_roles'
  belongs_to :yc_role
  belongs_to :user
end
# == Schema Information
#
# Table name: users_yc_roles
#
#  user_id    :integer(4)      not null
#  yc_role_id :integer(4)      not null
#

