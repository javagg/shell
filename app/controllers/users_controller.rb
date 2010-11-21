class UsersController < ApplicationController
  before_filter :require_user

  record_select :per_page => 5, :search_on => [:username]

  filter_access_to :all
  
  active_scaffold :users do |config|
    config.columns = [:username, :email, :roles]
    config.actions.exclude :create
    config.columns[:roles].form_ui = :record_select
    config.columns[:roles].form_ui = :select
    config.columns[:roles].options = { :draggable_lists => true }

    config.list.sorting = { :username => 'ASC' }
    config.actions.exclude :search
    config.actions << :field_search
  end
end
