class ContractPermissionsController < ApplicationController
  in_place_edit_for :contract_permissions, :can_read
  in_place_edit_for :contract_permissions, :can_write
  active_scaffold :contract_permissions do |config|
    config.columns = [ :contract, :can_read, :can_write ]
    config.columns[:contract].form_ui = :select
    config.columns[:can_read].form_ui = :select
    config.columns[:can_read].options = { :options => Shell::Options::shifou_options }
    config.columns[:can_read].inplace_edit = true
    config.columns[:can_write].form_ui = :select
    config.columns[:can_write].options = { :options => Shell::Options::shifou_options }
    config.columns[:can_write].inplace_edit = true
  end
end
