# == Schema Information
#
# Table name: payment_periods
#
#  id                 :integer(4)      not null, primary key
#  contract_id        :integer(4)
#  first_payment_date :date
#  start_date         :date
#  end_date           :date
#  num_payments       :integer(4)      default(1)
#

class PaymentPeriod < ActiveRecord::Base
  belongs_to :contract

  validates_numericality_of :num_payments, :only_integer => true, :greater_than => 0
  
  validate :end_date_cannot_be_less_than_start_date, 
    :first_payment_date_cannot_be_less_than_start_date,
    :end_date_cannot_be_less_than_first_payment_date

  def end_date_cannot_be_less_than_start_date
    errors.add(:end_date, I18n.t('cannot_be_less_than_start_date')) if end_date < start_date
  end

  def first_payment_date_cannot_be_less_than_start_date
    errors.add(:first_payment_date, I18n.t('cannot_be_less_than_start_date')) if first_payment_date < start_date
  end

  def end_date_cannot_be_less_than_first_payment_date
    errors.add(:end_date, I18n.t('cannot_be_less_than_first_payment_date')) if end_date < first_payment_date
  end
  
  def payment_dates
    dates = []
    dates << first_payment_date unless first_payment_date
    num_payments.times do |i|
      dates << first_payment_date + i * (end_date - first_payment_date) / num_payments
    end
    dates.uniq
  end

  include Shell::HasParentAssociation
  parent_association :contract
end

