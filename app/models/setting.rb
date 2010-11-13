class Setting < ActiveRecord::Base
end

# == Schema Information
#
# Table name: settings
#
#  id          :integer(4)      not null, primary key
#  var         :string(255)     not null
#  description :text
#  value       :text
#  created_at  :datetime
#  updated_at  :datetime
#

