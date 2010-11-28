class ExpirationReminding < ActiveRecord::Base
  belongs_to :reminder, :polymorphic => true
  belongs_to :user
end




# == Schema Information
#
# Table name: expiration_remindings
#
#  id                :integer(4)      not null, primary key
#  reminder_id       :integer(4)
#  reminder_type     :string(255)
#  user_id           :integer(4)
#  remindee_rejected :boolean(1)      default(FALSE)
#

