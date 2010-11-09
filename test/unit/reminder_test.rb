require 'test_helper'

class ReminderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

