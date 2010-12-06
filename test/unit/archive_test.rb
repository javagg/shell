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

  context "acts as authorized" do
    should have_many :archive_permissions
    should have_many :involved_yc_roles
    setup do
      @role_1 = YcRole.find 1
      @user_1 = User.find 1
      @user_2 = User.find 2
      @user_1.yc_roles << @role_1
      @user_2.yc_roles << @role_1
      @archive_1 = Archive.find(:first)
      perm_1 = ArchivePermission.new :archive => @archive_1, :can_write => true
      @role_1.archive_permissions << perm_1
    end

    should "contain 2 user" do
      assert @archive_1.users_having_permissions_on.include?(@user_1)
      assert @archive_1.users_having_permissions_on.include?(@user_2)
      puts  Archive.readable2_by_user(@user_1)
#      puts  Archive.writeable_by_user(@user_1)
    end
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

