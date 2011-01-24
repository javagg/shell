class YcroleArchivesController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  include Shell::YcroleDocumentControllerConfiguration
  
  active_scaffold :archives do |config|
    config.columns = [:number, :name, :issue_dep, :keep_dep, :keeper,
      :original_loc, :expired_on, :state, :has_backup, :backup_loc, :has_electrical_edtion,
      :confidential_level
    ]
    config_active_scaffold(config)

    config.columns[:keep_dep].form_ui = :select
    config.columns[:keep_dep].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::department_options }

    config.columns[:has_backup].form_ui = :select
    config.columns[:has_backup].options = { :options => Shell::Options::shifou_options }

    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options => Shell::Options::shifou_options }

    config.columns[:confidential_level].form_ui = :select
    config.columns[:confidential_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::confidential_level_options }
  end
end
