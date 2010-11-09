# == Schema Information
#
# Table name: assignments
#
#  id      :integer(4)      not null, primary key
#  user_id :integer(4)      not null
#  role_id :integer(4)      not null
#

class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end



