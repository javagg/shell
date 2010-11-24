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

  filter_access_to :all

  active_scaffold :contracts do |config|
    # for uploading file
    config.create.multipart = true
    config.update.multipart = true
    
    config.columns = [:number, :name, :station_name, :stamp_tax_type, :contract_type,
      :project_address, :trading_mode, :land_certificate_application_deadline, :property_certificate_application_deadline,
      :other_party, :contract_content, :start_date, :end_date, :expense_paid, :owning_department, :amount,
      :holder, :executive, :transferred, :state, :original_loc, :has_backup, :backup_loc, :has_electrical_edtion,
      :confidential_level, :memo, :payment_periods,
      :payments, :attachments, :reminding_periods
    ]
    config.subform.layout = :vertical
    config.list.columns = [:number, :name]
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
    config.columns[:stamp_tax_type].form_ui = :select
    config.columns[:stamp_tax_type].options = { :include_blank => I18n.t('txt.please_choose'),
      :options =>Shell::STAMP_TAX_TYPE_OPTIONS }
    config.columns[:contract_type].form_ui = :select
    config.columns[:contract_type].options = { :include_blank => I18n.t('txt.please_choose'),
      :options =>Shell::CONTRACT_TYPE_OPTIONS }
    config.columns[:trading_mode].form_ui = :select
    config.columns[:trading_mode].options = { :include_blank => I18n.t('txt.please_choose'),
      :options =>Shell::TRADING_MODE_OPTIONS }

    config.columns[:owning_department].form_ui = :select
    config.columns[:owning_department].options = { :include_blank => I18n.t('txt.please_choose'),
      :options =>Shell::DEPARTMENT_OPTIONS }

    config.columns[:confidential_level].form_ui = :select
    config.columns[:confidential_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options =>Shell::CONFIDENTIAL_LEVEL_OPTIONS }
  end

  def delete_authorized?
    permitted_to? :delete, :contracts
  end

  def create_authorized?
    permitted_to? :create, :contracts
  end

  def update_authorized?
    permitted_to? :update, :contracts
  end

  def list_authorized?
    permitted_to? :index, :contracts
  end

  def show_authorized?
    permitted_to? :show, :contracts
  end
end
