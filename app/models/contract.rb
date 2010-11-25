require 'date'

class Contract <  ActiveRecord::Base
  acts_as_audited

  validates_presence_of :name
  has_many :payments, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy

  has_many :payment_periods, :dependent => :destroy

  has_many :reminding_periods, :as => :reminder, :dependent => :destroy
  has_many :remindings, :as => :reminder, :dependent => :destroy
  has_many :expiration_remindees, :through => :remindings, :source => 'user'
  
  has_many :payment_remindings, :as => :reminder, :dependent => :destroy
  has_many :payment_remindees, :through => :payment_remindings, :source => 'user'

  def next_payment_date(from = Date.today)
    payment_dates.find_all { |e| e > from }.min
  end

  def expired?
    return false if end_date.nil?
    return end_date < Date.today
  end
  
  def payment_dates
    dates = []
    payment_periods.each do |period|
      dates.concat period.payment_dates
    end
    dates.uniq.sort
  end

  def remind_payment
    payment_remindees.each do | remindee |
      Emailer.deliver_contract_payment_reminding self, remindee
    end
  end

  def self.check_payment
    all_contracts = self.find :all
    all_contracts.each do |contract|
      payment_date = contract.next_payment_date
      if payment_date and payment_date > Date.today and payment_date < 1.week.from_now.to_date
        contract.remind_payment
      end
    end
  end
end

# == Schema Information
#
# Table name: contracts
#
#  id                                        :integer(4)      not null, primary key
#  number                                    :string(255)
#  name                                      :string(255)
#  description                               :text
#  station_name                              :string(255)
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
#  holder                                    :string(255)
#  executive                                 :string(255)
#  transferred                               :boolean(1)      default(FALSE)
#  state                                     :string(255)
#  original_loc                              :string(255)
#  has_backup                                :boolean(1)      default(FALSE)
#  backup_loc                                :string(255)
#  has_electrical_edtion                     :boolean(1)      default(FALSE)
#  confidential_level                        :string(255)
#  memo                                      :text
#  created_at                                :datetime
#  updated_at                                :datetime
#

