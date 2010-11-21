class RemindingPeriodsController < ApplicationController
  active_scaffold :reminding_periods do |config|
    config.columns = [ :start_date, :end_date, :num_remindings ]
    config.columns[:start_date].form_ui = :calendar_date_select
    config.columns[:end_date].form_ui = :calendar_date_select
  end
end
