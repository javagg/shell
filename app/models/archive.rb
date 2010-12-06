class Archive < ActiveRecord::Base
  acts_as_audited

  acts_as_expirable
  acts_as_attachable

  include Shell::Authorized
  
  acts_as_authorized self

  validates_presence_of :name

  def expiration_reminding_days
    Settings.expiration_reminding_days.to_i
  end

  #  def authorized_for_index?
  #    return false
  #  end
  #
  #  def authorized_for_delete?
  #    return false
  #  end
  #
  #  def authorized_for_update?
  #    return false
  #  end
  #
  #  def authorized_for_show?
  #    return false
  #  end
  #
  #  def authorized_for_create?
  #    return false
  #  end
end


# == Schema Information
#
# Table name: archives
#
#  id                    :integer(4)      not null, primary key
#  number                :string(255)
#  name                  :string(255)
#  description           :text
#  archive_type          :string(255)
#  issue_dep             :string(255)
#  keep_dep              :string(255)
#  keeper                :string(255)
#  original_loc          :string(255)
#  expired_on            :date
#  state                 :string(255)
#  has_backup            :boolean(1)      default(FALSE)
#  backup_loc            :string(255)
#  has_electrical_edtion :boolean(1)      default(FALSE)
#  confidential_level    :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

