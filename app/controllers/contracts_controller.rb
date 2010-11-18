class ContractsController < ApplicationController
  before_filter :require_user
  active_scaffold :contracts do |config|

    config.columns = [:number, :name, :description, :station_name, :stamp_tax_type, :contract_type,
      :project_address, :trading_mode, :land_certificate_application_deadline, :property_certificate_application_deadline,
      :other_party, :contract_content, :start_date, :end_date, :expense_paid, :owning_department, :amount,
      :holder, :executive, :transferred, :next_payment_date, :state, :original_loc, :has_backup, :backup_loc, :has_electrical_edtion,
      :security_level, :memo, :payment_periods, 
      :payments, :attachments
    ]

    config.list.columns = [:number, :name]
    #    config.nested.add_link I18n.t('contract.show_payments'), :payments
    #    config.nested.add_link I18n.t('document.show_attachments'), :attachments
    
    #    config.actions << :sortable
    #    config.sortable.column = :number
    config.nested.add_link I18n.t('contract.show_payments'), :payments
    config.nested.add_link I18n.t('document.show_attachments'), :attachments
    config.actions.exclude :search
    config.actions << :field_search
  end
end
