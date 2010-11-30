class LicensePermission < ActiveRecord::Base
  belongs_to :yc_role
  belongs_to :license
end


# == Schema Information
#
# Table name: license_permissions
#
#  id         :integer(4)      not null, primary key
#  yc_role_id :integer(4)
#  license_id :integer(4)
#  can_read   :boolean(1)      default(FALSE)
#  can_write  :boolean(1)      default(FALSE)
#

