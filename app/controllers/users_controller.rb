class UsersController < ApplicationController
  before_filter :require_user
  record_select :per_page => 5, :search_on => [:username]
  filter_access_to :all
  active_scaffold :users do |config|
    config.columns = [:username, :email, :ycroles]
    config.columns[:username].options = { :readonly => "readonly" }
    config.columns[:ycroles].form_ui = :select
    config.columns[:ycroles].options = { :draggable_lists => true }
    config.list.columns = [:username, :email]
    config.list.sorting = { :username => 'ASC' }
    config.actions.exclude :create

    # roles is allowed to edit by admin
    config.update.columns = [:username, :ycroles]
    config.update.link.label = I18n.t('txt.update_roles')
    config.actions.exclude :search
    config.actions << :field_search
    config.subform.columns = [ :username ]
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
