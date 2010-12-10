class LicensePermissionsController < ApplicationController
  class << self
    def permissions_active_scaffold_configurate(doc_name)
      doc = doc_name.to_sym
      permissions = "#{doc_name}_permissions".to_sym
      in_place_edit_for permissions, :can_read
      in_place_edit_for permissions, :can_write

      active_scaffold permissions do |config|
        config.columns = [ doc, :can_read, :can_write ]
        config.columns[doc].form_ui = :select
        config.columns[doc].clear_link
        config.show.columns = [doc]
        config.columns[:can_read].form_ui = :select
        config.columns[:can_read].options = { :options => Shell::Options::shifou_options }
        config.columns[:can_read].inplace_edit = true
        config.columns[:can_write].form_ui = :select
        config.columns[:can_write].options = { :options => Shell::Options::shifou_options }
        config.columns[:can_write].inplace_edit = true

        config.actions.exclude :show
        config.actions.exclude :delete
        config.actions.exclude :create
        config.update.link = false;
      end
    end
  end
  self.permissions_active_scaffold_configurate("license")
end
