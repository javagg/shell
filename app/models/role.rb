# == Schema Information
#
# Table name: roles
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Role < ActiveRecord::Base
  has_many :assignments, :dependent => :destroy
  has_many :users, :through => :assignments
end



