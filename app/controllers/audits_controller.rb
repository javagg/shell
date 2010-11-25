class AuditsController < ApplicationController
  active_scaffold :audits do |config|
    config.columns = [ :created_at, :user, :action, :auditable, :changes]
    config.actions.exclude :create
    config.actions.exclude :update
    config.action_links.add :empty, :action => "empty", :label => I18n.t('txt.empty'),
      :type => :collection, :confirm => I18n.t('txt.are_your_sure_to_empty'), :inline => false
    config.list.mark_records = true
  end

  def delete_marked
    
  end

  def empty
    Audit.delete_all
    return_to_main
  end
end
