class ArchivesController < ApplicationController
  layout 'site'
  auto_complete_for :archive, :name

  active_scaffold :archive do |config|
#    config.columns = [:number, :name, :archive_type, :description, :issue_dep,
#      :keep_dep, :keeper, :origin_loc, :expired_at, :state,
#      :has_backup, :backup_loc, :has_electrical_edtion, :security_level]
    config.columns = [:number, :name]
    config.actions.exclude :search
    config.actions << :field_search
    config.list.per_page = 10
  end
end