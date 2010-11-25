class Audit < ActiveRecord::Base
  def to_label
  end
end
# == Schema Information
#
# Table name: audits
#
#  id                    :integer(4)      not null, primary key
#  auditable_id          :integer(4)
#  auditable_type        :string(255)
#  auditable_parent_id   :integer(4)
#  auditable_parent_type :string(255)
#  user_id               :integer(4)
#  user_type             :string(255)
#  username              :string(255)
#  action                :string(255)
#  changes               :text
#  version               :integer(4)      default(0)
#  comment               :string(255)
#  created_at            :datetime
#

