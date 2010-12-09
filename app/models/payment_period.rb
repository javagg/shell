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

  validates_date :start_date, :first_payment_date, :end_date
  validates_date :end_date, :on_or_after => :start_date,
    :on_or_after_message => I18n.t('txt.cannot_be_less_than_start_date')
  validates_date :first_payment_date, :on_or_after => :start_date,
    :on_or_after_message => I18n.t('txt.cannot_be_less_than_start_date')
  validates_date :end_date, :on_or_after => :first_payment_date,
    :on_or_after_message => I18n.t('txt.cannot_be_less_than_first_payment_date')

  validates_numericality_of :num_payments, :only_integer => true, :greater_than => 0

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

