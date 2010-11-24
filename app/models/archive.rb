require 'date'

class Archive < ActiveRecord::Base
  validates_presence_of :name
  has_many :attachments, :as => :attachable, :dependent => :destroy

  has_many :remindings, :as => :reminder, :dependent => :destroy,
    :conditions => ['reminder_type = ?', "Archive"]
  has_many :expiration_remindees, :through => :remindings, :source => 'user'

  def expired?
    return false if expired_on.nil?
    return expired_on < Date.today
  end
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

