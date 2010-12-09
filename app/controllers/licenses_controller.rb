class LicensesController < ApplicationController
  before_filter :require_user
  
  active_scaffold :licenses do |config|
    # for uploading file
    config.create.multipart = true
    config.update.multipart = true

    config.columns = [:number, :name, :t5code, :area, :station_name,
      :issuing_authority, :state, :annual_inspection_date, :expired_on, :original_loc,
      :backup_loc, :memo, :owning_department, :has_electrical_edtion, :confidential_level,
      :expiration_remindees
    ]

    config.list.columns = [:number, :name, :expired_on]
    config.columns[:expiration_remindees].form_ui = :select
    config.columns[:expiration_remindees].options = { :draggable_lists => true }

    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options => Shell::Options::shifou_options }

    config.columns[:confidential_level].form_ui = :select
    config.columns[:confidential_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::confidential_level_options }

    config.columns[:memo].form_ui = :text_area
    config.columns[:memo].options = { :rows => 3, :cols => 40 }
    config.nested.add_link I18n.t('document.show_attachments'), :attachments
    config.actions.exclude :search
    config.actions << :field_search
  end

  def beginning_of_chain
    if params[:action] == "index"
      active_scaffold_config.model.readable_by_user current_user
    else
      active_scaffold_config.model
    end
  end
end
