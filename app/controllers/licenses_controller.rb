class LicensesController < ApplicationController
  active_scaffold :licenses do |config|
    config.columns = [:number, :name]
    config.nested.add_link I18n.t('document.show_attachments'), :attachments

    config.actions.exclude :search
    config.actions << :field_search
    config.list.per_page = 10
  end
end
