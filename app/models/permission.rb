class Permission < ActiveRecord::Base
  has_many :users
  has_many_polymorphs :manageables, :from => [:contracts, :archives, :licenses],
    :through => :permissions, :dependent => :destroy
end

# == Schema Information
#
# Table name: permissions
#
#  id              :integer(4)      not null, primary key
#  yc_roles_id     :integer(4)
#  manageable_id   :integer(4)
#  manageable_type :string(255)
#  can_read        :boolean(1)
#  can_write       :boolean(1)
#

