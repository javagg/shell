class ContractPermission < ActiveRecord::Base
  belongs_to :yc_role
  belongs_to :contract
end


# == Schema Information
#
# Table name: contract_permissions
#
#  id          :integer(4)      not null, primary key
#  yc_role_id  :integer(4)
#  contract_id :integer(4)
#  can_read    :boolean(1)      default(FALSE)
#  can_write   :boolean(1)      default(FALSE)
#

