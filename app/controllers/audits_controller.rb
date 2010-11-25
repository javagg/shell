class AuditsController < ApplicationController
  active_scaffold :audits do |config|
    config.columns = [ :created_at, :user, :action, :auditable, :changes]
    config.actions.exclude :create
    config.actions.exclude :update
    config.action_links.add :empty, :action => "empty", :label => I18n.t('txt.empty'), :type => :collection
  end

  def empty
    render :text => "all deteled!"

  end
end
