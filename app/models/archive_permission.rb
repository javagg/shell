class ArchivePermission < ActiveRecord::Base
  belongs_to :ycrole
  belongs_to :archive
end


# == Schema Information
#
# Table name: archive_permissions
#
#  id         :integer(4)      not null, primary key
#  ycrole_id  :integer(4)
#  archive_id :integer(4)
#  can_read   :boolean(1)      default(FALSE)
#  can_write  :boolean(1)      default(FALSE)
#

