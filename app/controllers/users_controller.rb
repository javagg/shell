class UsersController < ApplicationController
  before_filter :require_user

  record_select :per_page => 5, :search_on => [:username]

  filter_access_to :all

  before_filter :update_table_config

  active_scaffold :users do |config|
    config.columns = [:username, :email, :roles]
    config.columns[:roles].form_ui = :select
    config.columns[:roles].options = { :draggable_lists => true }
    config.list.sorting = { :username => 'ASC' }

    config.actions.exclude :create

    # roles is allowed to edit by admin
    config.update.columns = [:roles]
    config.update.link.label = I18n.t('txt.update_roles')
    config.actions.exclude :search
    config.actions << :field_search

    config.subform.columns = [ :username ]
  end
  
  def update_table_config
    if current_user.has_role?(:admin)
      active_scaffold_config.list.columns = [:username, :email]
    else
      active_scaffold_config.list.columns = [:username]
    end
  end
  
  def create_authorized?
    permitted_to? :create, :contracts
  end

  def update_authorized?
    permitted_to? :update, :contracts
  end

  def index_authorized?
    permitted_to? :index, :contracts
  end

  def show_authorized?
    permitted_to? :show, :contracts
  end

  def delete_authorized?
    permitted_to? :delete, :contracts
  end
end
