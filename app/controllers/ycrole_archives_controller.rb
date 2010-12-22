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
  end
end
