class SettingsController < ApplicationController
#  before_filter :require_user

  active_scaffold :setting do |config|
    config.columns = [:var, :description, :value]
  end
end
