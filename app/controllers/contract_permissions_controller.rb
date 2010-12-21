class ContractPermissionsController < ApplicationController
  include Shell::PermissionsActiveScaffoldConfiguration

  before_active_scaffold(:contract)
  active_scaffold :contract_permissions do |config|
    config_active_scaffold(config, :contract)
  end

end
