class UserYcrole < ActiveRecord::Base
  belongs_to :ycrole
  belongs_to :user
end


# == Schema Information
#
# Table name: user_ycroles
#
#  user_id   :integer(4)      not null
#  ycrole_id :integer(4)      not null
#

