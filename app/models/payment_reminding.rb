class PaymentReminding < ActiveRecord::Base
  belongs_to :reminder, :polymorphic => true
  belongs_to :user
end







# == Schema Information
#
# Table name: payment_remindings
#
#  id            :integer(4)      not null, primary key
#  reminder_id   :integer(4)
#  reminder_type :string(255)
#  user_id       :integer(4)
#  from          :datetime
#  to            :datetime
#

