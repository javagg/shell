
class Contract <  ActiveRecord::Base
  #acts_as_document
  has_many :payments, :dependent => :destroy
  has_many :reminders, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  
end




# == Schema Information
#
# Table name: contracts
#
#  id                                        :integer(4)      not null, primary key
#  number                                    :string(255)
#  name                                      :string(255)
#  description                               :text
#  stamp_tax_type                            :string(255)
#  contract_type                             :string(255)
#  project_address                           :string(255)
#  trading_mode                              :string(255)
#  land_certificate_application_deadline     :date
#  property_certificate_application_deadline :date
#  other_party                               :string(255)
#  contract_content                          :text
#  start_date                                :date
#  end_date                                  :date
#  expense_paid                              :string(255)
#  owning_department                         :string(255)
#  amount                                    :integer(10)
#  person_in_charge                          :string(255)
#  executive                                 :string(255)
#  state                                     :string(255)
#  origin_loc                                :string(255)
#  has_backup                                :boolean(1)
#  backup_loc                                :string(255)
#  has_electrical_edtion                     :boolean(1)      default(FALSE)
#  security_level                            :string(255)
#  created_at                                :datetime
#  updated_at                                :datetime
#

