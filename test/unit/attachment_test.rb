require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: attachments
#
#  id                :integer(4)      not null, primary key
#  attachable_id     :integer(4)
#  attachable_type   :string(255)
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  width             :integer(4)
#  height            :integer(4)
#  thumbnail         :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

