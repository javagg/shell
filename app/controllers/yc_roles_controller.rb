class YcRolesController < ApplicationController
  active_scaffold :yc_roles do |config|
    config.columns = [:name, :contract_permissions, :license_permissions, :archive_permissions ]
    config.list.columns = [ :name ]
    config.nested.add_link I18n.t('activerecord.attributes.yc_role.contract_permissions'), :contract_permissions
    config.nested.add_link I18n.t('activerecord.attributes.yc_role.license_permissions'), :license_permissions
    config.nested.add_link I18n.t('activerecord.attributes.yc_role.archive_permissions'), :archive_permissions
    config.actions.exclude :show
  end
end
