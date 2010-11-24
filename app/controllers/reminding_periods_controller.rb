class RemindingPeriodsController < ApplicationController
  active_scaffold :reminding_periods do |config|
    config.columns = [ :start_date, :end_date, :num_remindings ]
    config.subform.layout = :vertical
  end
end
