class Attachment < ActiveRecord::Base
  has_attached_file :data, :path => ":rails_root/data/attachments/:id/:style/:basename.:extension"

  belongs_to :attachable, :polymorphic => true
end
