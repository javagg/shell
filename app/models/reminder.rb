class Reminder < ActiveRecord::Base
  belongs_to :contract
  has_many :remindees, :class_name => "User"
end

# == Schema Information
#
# Table name: reminders
#
#  id          :integer(4)      not null, primary key
#  contract_id :integer(4)
#  when        :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

