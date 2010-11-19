class SettingsController < ApplicationController
  #  before_filter :require_user

  active_scaffold :settings do |config|
    config.actions.exclude :create
    config.actions.exclude :delete
    config.actions.exclude :show
    
    config.columns = [:var, :description, :value]
    config.columns[:var].options = { :disabled => true }
  end
end
