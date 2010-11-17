# == Schema Information
#
# Table name: documents
#
#  id          :integer(4)      not null, primary key
#  number      :string(255)
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Document < ActiveRecord::Base
  has_many :attachments, :as => :attachable, :dependent => :destroy
  
#  validate :validate_attachments
#
#  Max_Attachments = 5
#  Max_Attachment_Size = 1.megabyte
#
#  def validate_attachments
#    #    errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if assets.length > Max_Attachments
#    #    attachments.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
#  end
#
end

