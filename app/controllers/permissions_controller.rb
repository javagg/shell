class PermissionsController < ApplicationController
  active_scaffold :permissions do |config|
    config.columns = [ :manageable, :can_read, :can_write ]
  end
end
