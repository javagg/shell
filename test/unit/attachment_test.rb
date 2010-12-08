require File.dirname(__FILE__) + '/../test_helper'

class AttachmentTest < ActiveSupport::TestCase
  context "attachment" do
    setup do
      @contract = Contract.find 1
      @archive = Archive.find 1
      @attachment_1 = Attachment.new
      @attachment_2 = Attachment.new
      @contract.attachments << @attachment_1
      @archive.attachments << @attachment_2
    end

    should "parent not null" do
      puts @attachment_1.parent_sym
      puts @attachment_1.parent.name
      assert_equal @contract, @attachment_1.send(@attachment_1.parent_sym)
      assert_equal @archive, @attachment_2.send(@attachment_2.parent_sym)
    end
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

