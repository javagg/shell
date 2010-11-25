class AuditsController < ApplicationController
  active_scaffold :audits do |config|
    config.columns = [ :created_at, :user, :action, :auditable, :changes]
    config.actions.exclude :create
    config.actions.exclude :update

    config.action_links.add :empty, :label => I18n.t('txt.empty')
    config.action_links[:empty].type = :collection
    config.action_links[:empty].popup = true
  end

  def empty
    render :action => :index
  end
end
