class SettingsController < ApplicationController
  #  before_filter :require_user

  active_scaffold :setting do |config|
    config.actions.exclude :create
    config.actions.exclude :delete
    config.actions.exclude :show
    config.columns = [:var, :description, :value]
    config.columns[:var].options = { :disabled => true }
    config.columns[:description].form_ui = :textarea
    config.columns[:description].options = { :cols => 40, :rows => 3, :disabled => 'disabled' }

  end
end
