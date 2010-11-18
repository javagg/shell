class RemindingPeriod < ActiveRecord::Base
  belongs_to :reminder, :polymorphic => true
  belongs_to :license,  :class_name => "License",
    :foreign_key => "reminder_id"

  belongs_to :contract,  :class_name => "Contract",
    :foreign_key => "reminder_id"
end

# == Schema Information
#
# Table name: reminding_periods
#
#  id             :integer(4)      not null, primary key
#  reminder_id    :integer(4)
#  reminder_type  :string(255)
#  start_date     :date
#  end_date       :date
#  num_remindings :integer(4)      default(1)
#

