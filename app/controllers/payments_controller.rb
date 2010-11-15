class PaymentsController < ApplicationController
  active_scaffold :payment do |config|
     config.columns = [:pay_date, :amount]
  end
end
