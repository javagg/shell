class Payment < ActiveRecord::Base
  belongs_to :contract
end


# == Schema Information
#
# Table name: payments
#
#  id          :integer(4)      not null, primary key
#  contract_id :integer(4)
#  pay_date    :date
#  amount      :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

