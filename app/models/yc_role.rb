class YcRole < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :users_yc_roles, :dependent => :destroy, :class_name => 'UserYcRole'

  has_many :users, :through => :users_yc_roles
  
  has_many :license_permissions
  has_many :archive_permissions
  has_many :contract_permissions
  
  @@actions = [:read, :write]

  #  def can_read?(manageable)
  #    managealbe_class = manageable.class.to_s.downcase
  #    managealbe_permissions_class = manageable.class.to_s.downcase.concat('_permissions').to_sym
  #    permissions = self.send(managealbe_permissions_class)
  #    permissions.each do |permission|
  #      managealbe_id = permission.send(managealbe_class.concat('_id').to_sym)
  #      if managealbe_id == manageable.id
  #        return permission.can_read
  #      end
  #    end
  #    return false
  #  end

  def can_read?(manageable)
    can?(manageable, :read)
  end

  def can_write?(manageable)
    can?(manageable, :write)
  end
  
  def can?(manageable, method)
    can_method = 'can_'.concat(method.to_s).to_sym

    managealbe_class = manageable.class.to_s.downcase
    managealbe_permissions_class = manageable.class.to_s.downcase.concat('_permissions').to_sym
    permissions = self.send(managealbe_permissions_class)
    permissions.each do |permission|
      managealbe_id = permission.send(managealbe_class.concat('_id').to_sym)
      if managealbe_id == manageable.id
        return permission.send(can_method)
      end
    end
    return false
  end
  
end
# == Schema Information
#
# Table name: yc_roles
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#

