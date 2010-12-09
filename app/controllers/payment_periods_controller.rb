class PaymentPeriodsController < ApplicationController
  active_scaffold :payment_periods  do |config|
    config.columns = [ :start_date, :end_date, :first_payment_date, :num_payments ]
  end

  include Shell::CreationAuthorization
end
