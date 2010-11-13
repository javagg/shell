class ContractsController < ApplicationController
  before_filter :require_user
  active_scaffold :contract do |config|
    config.columns = [:number, :name, :description]
    config.nested.add_link I18n.t('contract.show_payments'), :payments
    config.nested.add_link I18n.t('contract.show_remidners'), :reminders
    config.nested.add_link I18n.t('document.show_attachments'), :attachments
    
    config.actions.exclude :search
    config.actions << :field_search
    config.list.per_page = 10
  end
end
