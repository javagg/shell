class LicensePermissionsController < ApplicationController
  include Shell::PermissionsActiveScaffoldConfiguration

  before_active_scaffold(:license)
  active_scaffold :license_permissions do |config|
    config_active_scaffold(config, :license)
  end
end
