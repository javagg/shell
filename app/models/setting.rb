class Setting < ActiveRecord::Base
  def to_label
    "#{var}"
  end

  validates_uniqueness_of :var
end


# == Schema Information
#
# Table name: settings
#
#  id          :integer(4)      not null, primary key
#  var         :string(255)     not null
#  description :text
#  value       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

