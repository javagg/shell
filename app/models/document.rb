class Document < ActiveRecord::Base
  has_many :attachments, :as => :attachable, :dependent => :destroy
end



# == Schema Information
#
# Table name: documents
#
#  id          :integer(4)      not null, primary key
#  number      :string(255)
#  name        :string(255)
#  description :text
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

