require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:username)
  should validate_uniqueness_of(:username)

  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  
  should have_many(:expiration_remindings)
  should have_many(:contract_expiration_remindings)
  should have_many(:license_expiration_remindings)
  should have_many(:archive_expiration_remindings)

  should have_many(:payment_remindings)

  #  should belong_to(:yc_roles)
  should have_and_belong_to_many(:yc_roles)
  
  context "A User instance" do
    setup do
      @user = User.find(:first)
    end

    should "return its username" do
      assert_equal 'alex', @user.username
    end

    context "User" do
      setup do
        @contract = Contract.find(:first)
        @archive = Archive.find(:first)
        @user = User.find(:first)
        @contract.expiration_remindees << @user
        @archive.expiration_remindees << @user
      end

      should "has a contract as a reminder" do
        assert @user.reminders.size == 2
        assert @user.contracts.size == 1
        assert @user.archives.size == 1
        assert @user.contract_expiration_remindings.size == 1
        assert @user.archive_expiration_remindings.size == 1
        assert @user.license_expiration_remindings.size == 0
        expiration_reminding = ExpirationReminding.find @user.contract_expiration_remindings.first.id
        assert !expiration_reminding.remindee_rejected
        @user.reject_expiration_remindings @user.contracts.first
        expiration_reminding = ExpirationReminding.find @user.contract_expiration_remindings.first.id
        assert expiration_reminding.remindee_rejected
      end

      should "has many yc_roles" do

      end
    end
    context "user yc_role" do
      setup do
        @user1 = User.find(1)
        @role1 = YcRole.find(1)
        @user2 = User.find(2)
        @role2 = YcRole.find(2)
      end

      should "has many yc_roles" do
        @user1.yc_roles << @role1
        @user1.yc_roles << @role2
        @user2.yc_roles << @role1
        @user2.yc_roles << @role2
        assert_equal 2, @user1.yc_roles.size
        assert_equal 'first_role', @user1.yc_roles[0].name
        assert_equal 'second_role', @user1.yc_roles[1].name

        assert_equal 'alex', @role1.users[0].username
        assert_equal 'alex_2', @role1.users[1].username

        assert_equal 'alex', @role2.users[0].username
        assert_equal 'alex_2', @role2.users[1].username
      end
    end

    context "Can user do this?" do
      setup do
        @user = User.find 1
        @yc_role = YcRole.find(1)
        @contract = Contract.find(1)
      end
      
      should "return true if he is allowed" do
        puts RAILS_ENV
        @yc_role.contract_permissions.clear
        assert !@yc_role.can_read?(@contract)

        @yc_role.contract_permissions.clear
        @user.yc_roles.clear
        perm_1 = ContractPermission.new :contract => @contract, :can_read => true
        @yc_role.contract_permissions << perm_1
        @user.yc_roles << @yc_role
        assert @user.can_read?(@contract)

        @yc_role.contract_permissions.clear
        @user.yc_roles.clear
        perm_2 = ContractPermission.new :contract => @contract, :can_read => false
        @yc_role.contract_permissions << perm_2
        @user.yc_roles << @yc_role
        assert !@user.can_read?(@contract)
      end
    end
  end
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

