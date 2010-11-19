class PaymentsController < ApplicationController
  active_scaffold :payments do |config|
     config.columns = [ :amount, :pay_date, :has_deliverables ]
  end
end
