class ContractsController < ApplicationController
  layout 'site'

  active_scaffold :contract do |config|
    #    config.columns = [:number, :name, :archive_type, :description, :issue_dep,
    #      :keep_dep, :keeper, :origin_loc, :expired_at, :state,
    #      :has_backup, :backup_loc, :has_electrical_edtion, :security_level]
    config.columns = [:number, :name, :description]
    config.nested.add_link I18n.t('contract.show_payments'), [:payments]
    config.nested.add_link I18n.t('contract.show_remidners'), [:reminders]
    config.actions.exclude :search
    config.actions << :field_search
    config.list.per_page = 10
  end
end
