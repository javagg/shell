class ArchivesController < ApplicationController
  before_filter :require_user
  filter_resource_access
  active_scaffold :archive do |config|
    config.columns = [:number, :name, :issue_dep, :keep_dep, :keeper,
      :origin_loc, :expired_at, :state, :has_backup, :backup_loc, :has_electrical_edtion,
      :security_level
    ]
    config.list.columns = [:number, :name, :description]
    config.nested.add_link I18n.t('document.show_attachments'), :attachments

    config.columns[:issue_dep].form_ui = :select
    config.columns[:issue_dep].options = { :options => Archive::DEPARTMENTS.map(&:to_sym)}

    config.columns[:keep_dep].form_ui = :select
    config.columns[:keep_dep].options = { :options => Archive::DEPARTMENTS.map(&:to_sym)}


    config.actions.exclude :search
    config.actions << :field_search
    config.list.per_page = 10
  end
end