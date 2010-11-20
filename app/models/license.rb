# == Schema Information
#
# Table name: licenses
#
#  id                     :integer(4)      not null, primary key
#  number                 :string(255)
#  name                   :string(255)
#  description            :text
#  t5code                 :integer(4)
#  area                   :string(255)
#  station_name           :string(255)
#  issuing_authority      :string(255)
#  issuing_date           :date
#  state                  :string(255)
#  annual_inspection_date :date
#  expired_on             :date
#  original_loc           :string(255)
#  backup_loc             :string(255)
#  memo                   :text
#  owning_department      :string(255)
#  has_electrical_edtion  :boolean(1)      default(FALSE)
#  security_level         :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class License <  ActiveRecord::Base
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :remindings, :as => :reminder, :dependent => :destroy
  has_many :expiration_remindees, :through => :remindings, :source => 'user'
  has_many :reminding_periods, :as => :reminder, :dependent => :destroy

  def remind_expiaration
    expiration_remindees.each do | remindee |
      Emailer.deliver_license_expiration_reminding self, remindee
    end
  end

  def self.check_expiration
    all_expirings = self.find :all,
      :conditions => ['expired_on > ? and expired_on < ? ', Time.now, 1.week.from_now]
    all_expirings.each do |expiring|
      expiring.remind_expiaration
    end
  end
end


