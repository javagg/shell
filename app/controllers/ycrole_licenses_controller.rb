class YcroleLicensesController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  include Shell::YcroleDocumentControllerConfiguration

  active_scaffold :licenses do |config|
    config.columns = [:number, :name, :t5code, :area, :station_name,
      :issuing_authority, :state, :annual_inspection_date, :expired_on, :original_loc,
      :backup_loc, :owning_department, :has_electrical_edtion, :confidential_level
    ]
    config_active_scaffold(config)
  end
end
