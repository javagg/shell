class LicensesController < ApplicationController
  active_scaffold :licenses do |config|
    config.columns = [:number, :name, :description, :t5code, :area, :station_name, :issuing_authority, :state, :annual_inspection_date,
        :expired_on, :original_loc, :backup_loc, :memo, :owning_department, :has_electrical_edtion,:security_level,:expiration_remindees
    ]

    config.list.columns = [:number, :name, :description, :expiration_remindees]
    config.columns[:expiration_remindees].form_ui = :select
    config.nested.add_link I18n.t('document.show_attachments'), :attachments
    config.actions.exclude :search
    config.actions << :field_search
  end
end
