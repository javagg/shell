class LicensePermissionsController < ApplicationController
  in_place_edit_for :license_permissions, :can_read
  in_place_edit_for :license_permissions, :can_write

  active_scaffold :license_permissions do |config|
    config.columns = [ :license, :can_read, :can_write ]
    config.columns[:license].form_ui = :select

    config.columns[:can_read].form_ui = :select
    config.columns[:can_read].options = { :options => Shell::Options::shifou_options }
    config.columns[:can_read].inplace_edit = true
    config.columns[:can_write].form_ui = :select
    config.columns[:can_write].options = { :options => Shell::Options::shifou_options }
    config.columns[:can_write].inplace_edit = true
  end
end
