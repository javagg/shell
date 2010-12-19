class YcrolesController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  active_scaffold :ycroles do |config|
    config.columns = [:name]
    config.nested.add_link I18n.t('activerecord.attributes.ycrole.contract_permissions'), :contract_permissions
    config.nested.add_link I18n.t('activerecord.attributes.ycrole.license_permissions'), :license_permissions
    config.nested.add_link I18n.t('activerecord.attributes.ycrole.archive_permissions'), :archive_permissions

    config.actions.exclude :show
    config.update.link = false
  end

  def beginning_of_chain
    active_scaffold_config.model.public
  end
end
