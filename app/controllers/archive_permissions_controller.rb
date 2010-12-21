class ArchivePermissionsController < ApplicationController
  include Shell::PermissionsActiveScaffoldConfiguration

  before_active_scaffold(:archive)
  active_scaffold :archive_permissions do |config|
    config_active_scaffold(config, :archive)
  end
end
