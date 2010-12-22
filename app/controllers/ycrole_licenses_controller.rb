class YcroleLicensesController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  include Shell::YcroleDocumentControllerConfiguration

  active_scaffold :licenses do |config|
    config.columns = [:number, :name
#      , :station_name, :stamp_tax_type, :contract_type,
#      :project_address, :trading_mode, :land_certificate_application_deadline, :property_certificate_application_deadline,
#      :other_party, :contract_content, :start_date, :end_date, :expense_paid, :owning_department, :amount,
#      :holder, :executive, :transferred, :state, :original_loc, :has_bacanckup, :backup_loc, :has_electrical_edtion,
#      :confidential_level
    ]
    config_active_scaffold(config)
  end
end
