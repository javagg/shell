class AdminController < ApplicationController
  active_scaffold :users do |config|
    config.columns = [:username, :email]
    config.list.sorting = {:username => 'ASC'}
    config.actions.exclude :search
    config.actions << :field_search
  end
end
