require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:username)
  should validate_uniqueness_of(:username)
  
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  
  should have_many :remindings
  should have_many(:reminders).through(:remindings)


  context "A User instance" do
    setup do
      @user = User.find(:first)
    end

    should "return its username" do
      assert_equal 'alex', @user.username
    end

    context "User Reminding" do
      setup do
        @contract = Contract.find(:first)
        @user = User.find(:first)
        @contract.expiration_remindees << @user
      end

      should "has a contract as a reminder" do
        assert !@user.reminders.nil?
      end
    end
  end

#  context "A user" do
#    setup { @user = Factory(:user) }
#
#    context "Delivering password instructions" do
#      setup { @user.deliver_password_reset_instructions! }
#
#      should_change("perishable token") { @user.perishable_token }
#      should "send an email" do
#        assert_sent_email
#      end
#    end
#  end
end






# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  username            :string(255)     not null
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  salt                :string(255)     not null
#  active              :boolean(1)      default(FALSE), not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

