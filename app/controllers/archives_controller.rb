class ArchivesController < ApplicationController
  before_filter :require_user

  include Shell::ControllerWithCommonFunctions

  active_scaffold :archives do |config|
    # for uploading file
    config.create.multipart = true
    config.update.multipart = true
    
    config.columns = [:number, :name, :issue_dep, :keep_dep, :keeper,
      :original_loc, :expired_on, :state, :has_backup, :backup_loc, :has_electrical_edtion,
      :confidential_level, :expiration_remindees
    ]
    
    config.subform.layout = :horizontal
    config.list.columns = [:number, :name, :expired_on]
    config.nested.add_link I18n.t('document.show_attachments'), :attachments

    config.columns[:keep_dep].form_ui = :select
    config.columns[:keep_dep].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::department_options }

    config.columns[:has_backup].form_ui = :select
    config.columns[:has_backup].options = { :options => Shell::Options::shifou_options }

    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options => Shell::Options::shifou_options }

    config.columns[:confidential_level].form_ui = :select
    config.columns[:confidential_level].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::Options::confidential_level_options }
    
    config.columns[:expired_on].description = I18n.t('txt.pick_a_date')

    config.columns[:expiration_remindees].form_ui = :select
    config.columns[:expiration_remindees].options = { :draggable_lists => true }

    config.actions.exclude :search
    config.actions << :field_search

    config.list.sorting = [{:number => :asc}, {:issue_dep => :asc}]

    config_active_scaffold(config)
  end

  def beginning_of_chain
    if params[:action] == "index"
      active_scaffold_config.model.readable_by_user(current_user)
    else
      active_scaffold_config.model
    end
  end

end