class PaymentsController < ApplicationController
  active_scaffold :payments do |config|
    config.columns = [ :amount, :pay_date, :has_deliverables ]
    config.columns[:has_deliverables].form_ui = :select
    config.columns[:has_deliverables].options = { :options =>Shell::SHIFOU_OPTIONS }
  end
end
