require File.dirname(__FILE__) + '/../test_helper'

class YcRoleTest < ActiveSupport::TestCase
  #
  #  should have_many :permissions
  context "A YcRole instance" do
    setup do
      @yc_role = YcRole.find(1)
      @contract = Contract.find(1)
    end

    #    should "has permissions on manageables" do
    #      @yc_role.manageables << @contract
    #      assert @yc_role.contracts.size == 1
    #      assert @yc_role.contracts[0].is_a?(Contract)
    #      assert @yc_role.permissions.size == 1
    #      assert @user.reminders.size == 2
    #      assert @user.contracts.size == 1
    #      assert @user.archives.size == 1
    #      assert @user.contract_expiration_remindings.size == 1
    #      assert @user.archive_expiration_remindings.size == 1
    #      assert @user.license_expiration_remindings.size == 0
    #      expiration_reminding = ExpirationReminding.find @user.contract_expiration_remindings.first.id
    #      assert !expiration_reminding.remindee_rejected
    #      @user.reject_expiration_remindings @user.contracts.first
    #      expiration_reminding = ExpirationReminding.find @user.contract_expiration_remindings.first.id
    #      assert expiration_reminding.remindee_rejected
    #    end
    should "can_read" do
      @yc_role.contract_permissions.clear
      assert !@yc_role.can_read?(@contract)
      
      perm_1 = ContractPermission.new :contract => @contract, :can_read => true
      @yc_role.contract_permissions << perm_1
      assert @yc_role.can_read?(@contract)

      @yc_role.contract_permissions.clear
      perm_2 = ContractPermission.new :contract => @contract, :can_read => false
      @yc_role.contract_permissions << perm_2
      assert !@yc_role.can_read?(@contract)
    end
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

