# == Schema Information
#
# Table name: remindings
#
#  id            :integer(4)      not null, primary key
#  reminder_id   :integer(4)
#  reminder_type :string(255)
#  user_id       :integer(4)
#  from          :datetime
#  to            :datetime
#

class Reminding < ActiveRecord::Base
  belongs_to :reminder, :polymorphic => true
  belongs_to :license,  :class_name => "License",
    :foreign_key => "reminder_id"

  belongs_to :contract,  :class_name => "Contract",
    :foreign_key => "reminder_id"
  
  belongs_to :user
end



