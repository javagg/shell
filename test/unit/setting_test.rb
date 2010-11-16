require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: settings
#
#  id          :integer(4)      not null, primary key
#  var         :string(255)     not null
#  description :text
#  value       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

