require File.dirname(__FILE__) + '/../test_helper'
require 'date'

class ContractTest < ActiveSupport::TestCase
  should have_many(:payments)
  should have_many(:payment_remindings)
  should have_many(:payment_remindees)
  should have_many(:involved_yc_roles)
  
  def test_payment_remind
    #    a_will_pay = Contract.new(:name => "will_pay")
    #    a_remindee = User.new(:username => 'remindee', :password => '12345',
    #      :password_confirmation => '12345', :email => 'lu.lee05@gmail.com')
    #    a_will_pay.save
    #    a_will_pay.payment_periods.create(:start_date => "2010-11-1", :end_date => "2011-10-1",
    #      :first_payment_date => "2010-11-25", :num_payments => 3)
    #    a_will_pay.payment_remindees << a_remindee
    #    Contract.check_payment
    #    Contract.destroy a_will_pay.id
    #    User.destroy a_remindee.id
  end

  def test_payment_dates
    contract = Contract.new(:name => "payment_test")
    contract.save
    contract.payment_periods.create :start_date => '2010-1-1', :end_date => '2010-12-31',
      :first_payment_date => '2010/2/1', :num_payments => 10

    contract.payment_periods.create :start_date => '2010-6-1', :end_date => '2010-12-31',
      :first_payment_date => '2010/10/1', :num_payments => 5
    #    puts contract.payment_dates
    from = Date.today
    #    puts contract.next_payment_date from
    Contract.destroy contract.id
  end

  def test_expiration
    contract = Contract.new :name => "test_contract", :end_date => "2010-10-11"
    assert_not_nil contract
    assert contract.expired?
  end

  context "Contract" do
    setup do
      @contract = Contract.find(:first)
      @user = User.find(:first)
    end

    should "create a payment_remindngs" do
      assert 'alex', @user.username
      @contract.payment_remindees << @user
    end
  end

  context "Contract are involved in many yc_roles" do
    setup do
      @contract_1 = Contract.find(:first)
      @role_1 = YcRole.find 1
      perm_1 = ContractPermission.new :contract => @contract_1, :can_read => true
      @role_1.contract_permissions << perm_1
      @role_1.save

      @role_2 = YcRole.find 2
      perm_2 = ContractPermission.new :contract => @contract_1, :can_read => true
      @role_2.contract_permissions << perm_2
      @role_2.save

      @contract_2 = Contract.find 2
      perm_3 = ContractPermission.new :contract => @contract_2, :can_read => true
      @role_1.contract_permissions << perm_3
      @role_1.save

      user_1 = User.find 1
      user_1.yc_roles << @role_1
      user_1.yc_roles << @role_2
    end

    should "involed" do
      assert_equal 2, @contract_1.involved_yc_roles.size
      assert_equal 'first_role', @contract_1.involved_yc_roles.first.name
      assert_equal 'second_role', @contract_1.involved_yc_roles[1].name
    end
  end

  context "" do
    setup do
      @role_1 = YcRole.find 1
      @user_1 = User.find 1
      @user_2 = User.find 2
      @user_1.yc_roles << @role_1
      @user_2.yc_roles << @role_1
      @contract_1 = Contract.find(:first)
      perm_1 = ContractPermission.new :contract => @contract_1, :can_read => true
      @role_1.contract_permissions << perm_1
      @role_1.save
    end

    should "contain 2 user" do
      assert @contract_1.users_having_permissions_on.include?(@user_1)
      assert @contract_1.users_having_permissions_on.include?(@user_2)
      puts Contract.can_read2(@user_1)
    end
  end
end









# == Schema Information
#
# Table name: contracts
#
#  id                                        :integer(4)      not null, primary key
#  number                                    :string(255)
#  name                                      :string(255)
#  description                               :text
#  station_name                              :string(255)
#  stamp_tax_type                            :string(255)
#  contract_type                             :string(255)
#  project_address                           :string(255)
#  trading_mode                              :string(255)
#  land_certificate_application_deadline     :date
#  property_certificate_application_deadline :date
#  other_party                               :string(255)
#  contract_content                          :text
#  start_date                                :date
#  end_date                                  :date
#  expense_paid                              :string(255)
#  owning_department                         :string(255)
#  amount                                    :integer(10)
#  holder                                    :string(255)
#  executive                                 :string(255)
#  transferred                               :boolean(1)      default(FALSE)
#  state                                     :string(255)
#  original_loc                              :string(255)
#  has_backup                                :boolean(1)      default(FALSE)
#  backup_loc                                :string(255)
#  has_electrical_edtion                     :boolean(1)      default(FALSE)
#  confidential_level                        :string(255)
#  memo                                      :text
#  created_at                                :datetime
#  updated_at                                :datetime
#

