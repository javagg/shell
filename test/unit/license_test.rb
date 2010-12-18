require File.dirname(__FILE__) + '/../test_helper'

class LicenseTest < ActiveSupport::TestCase
 
#  def test_expiration_remind
#    a_will_expired = License.new(:name => "will_expired", :expired_on => 2.days.from_now)
#    a_remindee = User.new(:username => 'remindee', :password => '12345',
#      :password_confirmation => '12345', :email => 'lu.lee05@gmail.com')
#    a_will_expired.save
#    a_will_expired.expiration_remindees << a_remindee
#    all_expired = License.find :all,
#      :conditions => ['expired_on > ? and expired_on < ? ', Time.now, 1.week.from_now]
#    all_expired.each do |will_expired|
#      will_expired.remind_expiaration
#    end
#
#    License.destroy a_will_expired.id
#    User.destroy a_remindee.id
#  end
#
#  def test_expired
#    days_before_expiration = Settings.reminding_days_before_expiration
#    expiration_date = Date.today + days_before_expiration
#    a_will_expired = License.new(:name => "will_expired", :expired_on => expiration_date)
#    assert a_will_expired.expired?
#  end
end




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
#  confidential_level     :string(255)
#  user_id                :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

