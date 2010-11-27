require 'test_helper'

class RemindingPeriodTest < ActiveSupport::TestCase

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

