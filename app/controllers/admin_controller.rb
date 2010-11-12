class AdminController < ApplicationController
  active_scaffold :user do |config|
    config.columns = [:username, :email]
    config.nested.add_link I18n.t('user.show_roles'), [:roles]
    config.list.sorting = {:username => 'ASC'}
    config.actions.exclude :search
    config.actions << :field_search
  end
end
