class YcRole < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :users
  
  has_many :license_permissions
  has_many :archive_permissions
  has_many :contract_permissions
end
# == Schema Information
#
# Table name: yc_roles
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#

