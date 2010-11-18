require 'test_helper'

class PaymentPeriodTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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

