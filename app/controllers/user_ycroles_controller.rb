class UserYcrolesController < ApplicationController
  active_scaffold :user_ycroles do |config|
    config.columns = [:user, :ycrole]
    config.columns[:user].clear_link
    config.columns[:ycrole].clear_link
    config.columns[:user].form_ui = :select
    config.columns[:ycrole].form_ui = :select
  end
end