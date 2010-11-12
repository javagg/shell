class DocumentsController < ApplicationController
  active_scaffold :document do |config|
    config.create.multipart = true
    config.update.multipart = true
    config.columns = [:number, :name, :description, :attachments]
    config.list.columns = [:number, :name, :description]
    config.search.columns.exclude :attachments
    config.nested.add_link I18n.t('document.show_attachments'), [:attachments]
    config.actions.exclude :search
    config.actions << :field_search
    config.list.empty_field_text = I18n.t 'active_scaffold.column_is_null'
    config.label = I18n.t 'document.tag'
  end
end
