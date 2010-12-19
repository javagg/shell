require 'spreadsheet'

class ContractsController < ApplicationController
  uses_tiny_mce(:options => {:theme => 'advanced',
      :browsers => %w{msie gecko},
      :theme_advanced_toolbar_location => "top",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_resizing => true,
      :theme_advanced_resize_horizontal => false,
      :paste_auto_cleanup_on_paste => true,
      :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink undo redo},
      :theme_advanced_buttons2 => [],
      :theme_advanced_buttons3 => [],
      :plugins => %w{contextmenu paste}},
    :only => [:new, :edit, :show, :index])

  before_filter :require_user

  active_scaffold :contracts do |config|
    # for uploading file
    config.create.multipart = true
    config.update.multipart = true
    
    config.columns = [:number, :name, :station_name, :stamp_tax_type, :contract_type,
      :project_address, :trading_mode, :land_certificate_application_deadline, :property_certificate_application_deadline,
      :other_party, :contract_content, :start_date, :end_date, :expense_paid, :owning_department, :amount,
      :holder, :executive, :transferred, :state, :original_loc, :has_backup, :backup_loc, :has_electrical_edtion,
      :confidential_level, :memo, :expiration_remindees, :payment_remindees
    ]

    config.subform.layout = :vertical
    config.list.columns = [:number, :name, :end_date, :next_payment_date]
    config.nested.add_link I18n.t('contract.show_payments'), :payments
    config.nested.add_link I18n.t('document.show_attachments'), :attachments
    config.nested.add_link I18n.t('contract.show_payment_periods'), :payment_periods
    config.actions.exclude :search
    config.actions << :field_search
    config.columns[:contract_content].form_ui = :text_editor
    config.columns[:transferred].form_ui = :select
    config.columns[:transferred].options = { :options => Shell::Options::shifou_options }
    config.columns[:has_backup].form_ui = :select
    config.columns[:has_backup].options = { :options => Shell::Options::shifou_options }
    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options => Shell::Options::shifou_options }
    config.columns[:memo].form_ui = :test_area
    config.columns[:memo].options = {:cols => 40, :rows => 3 }
    config.columns[:stamp_tax_type].form_ui = :select
    config.columns[:stamp_tax_type].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::stamp_tax_type_options }
    config.columns[:contract_type].form_ui = :select
    config.columns[:contract_type].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::contract_type_options }
    config.columns[:trading_mode].form_ui = :select
    config.columns[:trading_mode].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::trading_mode_options }

    config.columns[:owning_department].form_ui = :select
    config.columns[:owning_department].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::department_options }

    config.columns[:confidential_level].form_ui = :select
    config.columns[:confidential_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::confidential_level_options }

    [config.update.columns, config.create.columns].each do |action|
      action.add_subgroup I18n.t("document.reminders") do |group|
        group.add :expiration_remindees, :payment_remindees
        group.label = I18n.t("contract.reminders_with_explanation")
      end
    end

    config.columns[:expiration_remindees].form_ui = :select
    config.columns[:expiration_remindees].options = { :draggable_lists => true }
    config.columns[:payment_remindees].form_ui = :select
    config.columns[:payment_remindees].options = { :draggable_lists => true }

    config.action_links.add :upload_xls_file, :label => I18n.t('txt.import')
    config.action_links[:upload_xls_file].type = :collection
  end

  def beginning_of_chain
    if params[:action] == "index"
      active_scaffold_config.model.readable_by_user current_user
    else
      active_scaffold_config.model
    end
  end

  def upload_xls_file
    render :partial => "app/views/upload/upload_xls_file.erb"
  end
  
  def import
    file = params[:upload][:xlsfile]
    if !file.original_filename.empty?
      filename = "#{RAILS_ROOT}/tmp/#{file.original_filename}"
      File.open(filename, "wb") do |f|
        f.write(file.read)
      end
      
      book = Spreadsheet.open(filename)
      sheet = book.worksheet(0)
      sheet.each_with_index do |row, i|
        puts row, i
      end

      File.delete(filename)
      
      redirect_to contracts_path
    end
  end
end
