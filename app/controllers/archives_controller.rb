class ArchivesController < ApplicationController
  before_filter :require_user

  filter_access_to :all

  active_scaffold :archives do |config|
    config.columns = [:number, :name, :issue_dep, :keep_dep, :keeper,
      :original_loc, :expired_on, :state, :has_backup, :backup_loc, :has_electrical_edtion,
      :security_level
    ]
    config.list.columns = [:number, :name, :description, :has_electrical_edtion]
    config.nested.add_link I18n.t('document.show_attachments'), :attachments

    config.columns[:issue_dep].form_ui = :select
    config.columns[:issue_dep].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::DEPARTMENT_OPTIONS }

    config.columns[:keep_dep].form_ui = :select
    config.columns[:keep_dep].options = { :include_blank => I18n.t('txt.please_choose'),
      :options => Shell::DEPARTMENT_OPTIONS }

    config.columns[:has_backup].form_ui = :select
    config.columns[:has_backup].options = { :options => Shell::SHIFOU_OPTIONS }

    config.columns[:has_electrical_edtion].form_ui = :select
    config.columns[:has_electrical_edtion].options = { :options =>Shell::SHIFOU_OPTIONS }

    config.columns[:expired_on].description = I18n.t('txt.pick_a_date')

    config.actions.exclude :search
    config.actions << :field_search
    config.list.per_page = 10
  end

  def delete_authorized?
    permitted_to? :delete, :archives
  end

  def create_authorized?
    permitted_to? :create, :archives
  end

  def update_authorized?
    permitted_to? :update, :archives
  end

  def list_authorized?
    permitted_to? :index, :archives
  end

  def show_authorized?
    permitted_to? :show, :archives
  end

  def do_destroy
    record = Archive.find_by_id(params[:id])
#    log = Log.create(:description => "Deleted prospect #{record.name}", :created_by => current_user.name)
#    log.save
    super
  end
end