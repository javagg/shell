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

class Attachment < ActiveRecord::Base
  def to_label
    data_file_name
  end

  has_attached_file :data, :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_size :data, :less_than => eval("Settings.upload_limit")
  belongs_to :attachable, :polymorphic => true
end
