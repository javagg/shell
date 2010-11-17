# == Schema Information
#
# Table name: licenses
#
#  id                     :integer(4)      not null, primary key
#  number                 :string(255)
#  name                   :string(255)
#  description            :text
#  t5code                 :integer(4)
#  area                   :string(255)
#  station_name           :string(255)
#  issuing_authority      :string(255)
#  issuing_date           :date
#  state                  :string(255)
#  annual_inspection_date :date
#  expired_on             :date
#  original_loc           :string(255)
#  backup_loc             :string(255)
#  memo                   :text
#  owning_department      :string(255)
#  has_electrical_edtion  :boolean(1)      default(FALSE)
#  security_level         :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class License <  ActiveRecord::Base
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :remindings, :as => :reminder
  has_many :expiration_remindees, :through => :remindings, :source => 'user'
end


