require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  should belong_to(:contract)
  should validate_numericality_of(:amount)
end

# == Schema Information
#
# Table name: payments
#
#  id               :integer(4)      not null, primary key
#  contract_id      :integer(4)
#  pay_date         :date
#  amount           :integer(10)
#  has_deliverables :boolean(1)      default(FALSE)
#  memo             :text
#  created_at       :datetime
#  updated_at       :datetime
#

