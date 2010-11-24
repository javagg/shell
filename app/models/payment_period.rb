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
  
  def payment_dates
    dates = []
    dates << first_payment_date unless first_payment_date
    num_payments.times do |i|
      dates << first_payment_date + i * (end_date - first_payment_date) / num_payments
    end
    dates.uniq
  end
end

