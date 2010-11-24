require File.dirname(__FILE__) + '/../test_helper'

class PaymentPeriodTest < ActiveSupport::TestCase
  def test_payment_date
    period = PaymentPeriod.new :start_date => '2010-1-1', :end_date => '2010-12-31',
      :first_payment_date => '2010/2/1', :num_payments => 10
#    puts period.payment_dates
    assert period.payment_dates.first == period.first_payment_date
    assert period.payment_dates.size == period.num_payments
  end
end


# == Schema Information
#
# Table name: payment_periods
#
#  id                 :integer(4)      not null, primary key
#  contract_id        :integer(4)
#  first_payment_date :date
#  start_date         :date
#  end_date           :date
#  num_payments       :integer(4)      default(1)
#

