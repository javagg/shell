class LicensesController < ApplicationController
  before_filter :require_user
  
  filter_access_to :all

  active_scaffold :licenses do |config|
#    config.actions << :download
    config.columns = [:number, :name, :t5code, :area, :station_name,
      :issuing_authority, :state, :annual_inspection_date, :expired_on, :original_loc,
      :backup_loc, :memo, :owning_department, :has_electrical_edtion, :security_level,
      :expiration_remindees, :attachments, :reminding_periods
    ]

    config.list.columns = [:number, :name, :expiration_remindees]
    config.columns[:expiration_remindees].form_ui = :select
    config.columns[:expiration_remindees].options = { :draggable_lists => true }

    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options =>Shell::SHIFOU_OPTIONS }

    config.columns[:security_level].form_ui = :select
    config.columns[:security_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options =>Shell::CONFIDENTIAL_LEVEL_OPTIONS }

    config.columns[:memo].form_ui = :text_area
    config.columns[:memo].options = { :rows => 3, :cols => 40 }
    config.nested.add_link I18n.t('document.show_attachments'), :attachments
    config.actions.exclude :search
    config.actions << :field_search
  end

  def delete_authorized?
    permitted_to? :delete, :licenses
  end

  def create_authorized?
    permitted_to? :create, :licenses
  end

  def update_authorized?
    permitted_to? :update, :licenses
  end
  
  def list_authorized?
    permitted_to? :index, :licenses
  end

  def show_authorized?
    permitted_to? :show, :licenses
  end

  def download
    
  end
end
