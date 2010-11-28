class PaymentReminding < ActiveRecord::Base
  belongs_to :contract
  belongs_to :user
end




# == Schema Information
#
# Table name: payment_remindings
#
#  id                :integer(4)      not null, primary key
#  contract_id       :integer(4)
#  user_id           :integer(4)
#  remindee_rejected :boolean(1)      default(FALSE)
#

