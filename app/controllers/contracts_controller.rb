class ContractsController < ApplicationController
  uses_tiny_mce(:options => {:theme => 'advanced',
      :browsers => %w{msie gecko},
      :theme_advanced_toolbar_location => "top",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_resizing => true,
      :theme_advanced_resize_horizontal => false,
      :paste_auto_cleanup_on_paste => true,
      :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink image undo redo},
      :theme_advanced_buttons2 => [],
      :theme_advanced_buttons3 => [],
      :plugins => %w{contextmenu paste}},
    :only => [:new, :edit, :show, :index])

  before_filter :require_user
  active_scaffold :contracts do |config|
    config.columns = [:number, :name, :station_name, :stamp_tax_type, :contract_type,
      :project_address, :trading_mode, :land_certificate_application_deadline, :property_certificate_application_deadline,
      :other_party, :contract_content, :start_date, :end_date, :expense_paid, :owning_department, :amount,
      :holder, :executive, :transferred, :state, :original_loc, :has_backup, :backup_loc, :has_electrical_edtion,
      :security_level, :memo, :payment_periods,
      :payments, :attachments, :reminding_periods
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
    config.columns[:contract_content].form_ui = :text_editor
    config.columns[:transferred].form_ui = :select
    config.columns[:transferred].options = { :options =>Shell::SHIFOU_OPTIONS }
    config.columns[:has_backup].form_ui = :select
    config.columns[:has_backup].options = { :options =>Shell::SHIFOU_OPTIONS }
    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options =>Shell::SHIFOU_OPTIONS }
    config.columns[:memo].form_ui = :test_area
    config.columns[:memo].options = {:cols => 40, :rows => 3 }

  end
end
