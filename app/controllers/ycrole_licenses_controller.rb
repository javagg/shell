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

    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options => Shell::Options::shifou_options }

    config.columns[:owning_department].form_ui = :select
    config.columns[:owning_department].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::department_options }

    config.columns[:confidential_level].form_ui = :select
    config.columns[:confidential_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::confidential_level_options }
  end
end
