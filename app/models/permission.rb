class Permission < ActiveRecord::Base
  belongs_to :ycrole
  belongs_to :manageable, :polymorphic => true
end

# == Schema Information
#
# Table name: permissions
#
#  id              :integer(4)      not null, primary key
#  ycrole_id       :integer(4)
#  manageable_id   :integer(4)
#  manageable_type :string(255)
#  can_read        :boolean(1)
#  can_write       :boolean(1)
#

