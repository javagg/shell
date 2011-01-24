class YcroleContractsController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  include Shell::YcroleDocumentControllerConfiguration

  active_scaffold :contracts do |config|
    config.columns = [:number, :name, :station_name, :stamp_tax_type, :contract_type,
      :project_address, :trading_mode, :land_certificate_application_deadline, :property_certificate_application_deadline,
      :other_party, :contract_content, :start_date, :end_date, :expense_paid, :owning_department, :amount,
      :holder, :executive, :transferred, :state, :original_loc, :has_bacanckup, :backup_loc, :has_electrical_edtion,
      :confidential_level
    ]
    config_active_scaffold(config)

    config.columns[:transferred].form_ui = :select
    config.columns[:transferred].options = { :options => Shell::Options::shifou_options }
    config.columns[:has_backup].form_ui = :select
    config.columns[:has_backup].options = { :options => Shell::Options::shifou_options }
    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options => Shell::Options::shifou_options }
    config.columns[:stamp_tax_type].form_ui = :select
    config.columns[:stamp_tax_type].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::stamp_tax_type_options }
    config.columns[:contract_type].form_ui = :select
    config.columns[:contract_type].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::contract_type_options }
    config.columns[:trading_mode].form_ui = :select
    config.columns[:trading_mode].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::trading_mode_options }
    config.columns[:owning_department].form_ui = :select
    config.columns[:owning_department].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::department_options }
    config.columns[:confidential_level].form_ui = :select
    config.columns[:confidential_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::confidential_level_options }
  end
end
