require File.dirname(__FILE__) + '/../test_helper'

class ArchiveTest < ActiveSupport::TestCase

  def test_expired
    days_before_expiration = Settings.reminding_days_before_expiration
    expiration_date = Date.today + days_before_expiration.to_i
    a_will_expired =  Archive.new(:name => "will_expired", :expired_on => expiration_date)
    a_will_expired.expired_on = Date.today
    assert !a_will_expired.expired?
    a_will_expired.expired_on = Date.today - 1
    assert a_will_expired.expired?
    a_will_expired.expired_on = Date.today + days_before_expiration.to_i + 1
    assert !a_will_expired.expiring?
    a_will_expired.expired_on = Date.today + days_before_expiration.to_i
    assert a_will_expired.expiring?
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

