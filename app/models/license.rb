# == Schema Information
#
# Table name: licenses
#
#  id                     :integer(4)      not null, primary key
#  number                 :string(255)
#  name                   :string(255)
#  description            :text
#  sequence               :integer(4)
#  area                   :string(255)
#  station_name           :string(255)
#  license_type           :string(255)
#  issuing_authority      :string(255)
#  issuing_date           :date
#  annual_inspection_date :date
#  expired_on             :date
#  filing_location        :string(255)
#  memo                   :text
#  owning_department      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class License <  ActiveRecord::Base
  has_many :attachments, :as => :attachable, :dependent => :destroy
end


