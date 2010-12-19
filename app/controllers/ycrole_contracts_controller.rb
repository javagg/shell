class YcroleContractsController < ApplicationController

  active_scaffold :contracts do |config|
    config.columns = [:number, :name, :station_name, :stamp_tax_type, :contract_type,
      :project_address, :trading_mode, :land_certificate_application_deadline, :property_certificate_application_deadline,
      :other_party, :contract_content, :start_date, :end_date, :expense_paid, :owning_department, :amount,
      :holder, :executive, :transferred, :state, :original_loc, :has_bacanckup, :backup_loc, :has_electrical_edtion,
      :confidential_level
    ]

    config.list.columns = [:number, :name]
    config.list.mark_records = true
    config.actions.exclude :create
    config.actions.exclude :update
    config.actions.exclude :show
    config.actions.exclude :delete

    config.actions.exclude :search
    config.actions << :field_search
    config.list.mark_records = true
    config.action_links.add :batch_set, :label => I18n.t('txt.batch_set')
    config.action_links[:batch_set].type = :collection
  end

  def self.config_activescaffold(config)

  end
  
  def batch_set
    @selected_ids = marked_records.to_a
    @selecteds = Contract.find @selected_ids
    render :template => "app/views/ycroles/batch_set.erb"
  end

  def batch_set_permissions
    role = Ycrole.find_by_name params[:ycrole]
    puts "ids: #{params[:selected_ids]}"
    selected_ids = params[:selected_ids].split(",")
    selected = Contract.find selected_ids
    selected.each do |select|
      permission = ContractPermission.find(:first, :conditions => {:ycrole_id => role.id, :contract_id => select.id })
      if permission
        permission.can_read = params[:read_action]
        permission.can_write = params[:write_action]
        permission.save
      end
    end
    render :nothing => true
  end
end
