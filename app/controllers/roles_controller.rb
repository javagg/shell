class RolesController < ApplicationController
  def to_label
    "#{name}"
  end
  
  record_select :search_on => [:name]

  active_scaffold :roles do |config|
    config.columns = [:name, :description]
    config.actions.exclude :create
    config.actions.exclude :update
    config.actions.exclude :delete
    config.actions.exclude :show
    config.actions.exclude :search
    config.actions.exclude :nested
  end
end
