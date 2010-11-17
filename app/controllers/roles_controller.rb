class RolesController < ApplicationController
  record_select :search_on => 'name'

  active_scaffold :role do |config|
    config.actions.exclude :create
    config.actions.exclude :update
    config.actions.exclude :delete
    config.actions.exclude :show
    config.actions.exclude :search
    config.actions.exclude :nested
  end
end
