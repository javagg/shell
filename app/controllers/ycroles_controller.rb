class YcrolesController < ApplicationController
  active_scaffold :ycroles do |config|
    config.columns = [:name, :contract_permissions, :license_permissions, :archive_permissions ]
    config.list.columns = [ :name ]
    config.nested.add_link I18n.t('activerecord.attributes.ycrole.contract_permissions'), :contract_permissions
    config.nested.add_link I18n.t('activerecord.attributes.ycrole.license_permissions'), :license_permissions
    config.nested.add_link I18n.t('activerecord.attributes.ycrole.archive_permissions'), :archive_permissions
    config.actions.exclude :show
  end
end
