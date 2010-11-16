class Payment < ActiveRecord::Base
  belongs_to :contract
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
#  created_at       :datetime
#  updated_at       :datetime
#

