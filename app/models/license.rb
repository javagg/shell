class License <  ActiveRecord::Base
  acts_as_audited

  acts_as_expirable
  acts_as_attachable

  include Shell::Authorized
  acts_as_authorized
  
  validates_presence_of :name
  validates_uniqueness_of :name

  def expiration_reminding_days
    Settings.expiration_reminding_days.to_i
  end
end



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
#  confidential_level     :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

