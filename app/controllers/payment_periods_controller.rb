class PaymentPeriodsController < ApplicationController
  active_scaffold :payment_periods  do |config|
    config.columns = [ :start_date, :end_date, :first_payment_date, :num_payments ]
    config.columns[:start_date].form_ui = :calendar_date_select
    config.columns[:end_date].form_ui = :calendar_date_select
    config.columns[:first_payment_date].form_ui = :calendar_date_select
  end
end
