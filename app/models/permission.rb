class Permission < ActiveRecord::Base
  belongs_to :yc_role
  belongs_to :manageable, :polymorphic => true
end


# == Schema Information
#
# Table name: permissions
#
#  id              :integer(4)      not null, primary key
#  yc_role_id      :integer(4)
#  manageable_id   :integer(4)
#  manageable_type :string(255)
#  can_read        :boolean(1)
#  can_write       :boolean(1)
#

