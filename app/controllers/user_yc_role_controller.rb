class UserYcRoleController < ApplicationController
  active_scaffold 'UserYcRole' do |config|
    config.columns = [:user, :yc_role]
    config.columns[:user].form_ui = :select
    config.columns[:yc_role].form_ui = :select
  end
end