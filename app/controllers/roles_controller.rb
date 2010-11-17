class RolesController < ApplicationController
  record_select :per_page => 5, :search_on => 'name'

  active_scaffold :role do |config|
    config.actions.exclude :update
    config.actions.exclude :search
  end
end
