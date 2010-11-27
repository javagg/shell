class RemindingsController < ApplicationController
  in_place_edit_for :remindings, :remindee_rejected
  def to_label
    "reminding"
  end
  
  active_scaffold :remindings do |config|

    config.columns = [:user, :reminder, :reminder_type, :remindee_rejected ]
    config.columns << :reminder_type
    config.columns[:user].clear_link

    config.columns[:remindee_rejected].inplace_edit = true
    config.actions.exclude :create
    config.actions.exclude :delete
    config.actions.exclude :search
    config.update.link = false
    config.actions.exclude :show
  end
end
