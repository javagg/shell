class ExpirationRemindingsController < ApplicationController
  in_place_edit_for :expiration_remindings, :remindee_rejected
  def to_label
    "expiration_reminding"
  end
  
  active_scaffold :expiration_remindings do |config|
    config.columns = [ :user, :reminder, :reminder_type, :remindee_rejected ]
    config.columns << :reminder_type
    config.columns[:user].clear_link

    config.list.columns = [ :reminder, :reminder_type, :remindee_rejected ]
    config.columns[:remindee_rejected].form_ui = :select
    config.columns[:remindee_rejected].options = { :options => Shell::Options::shifou_options }
    config.columns[:remindee_rejected].inplace_edit = true

    config.actions.exclude :create
    config.actions.exclude :delete
    config.actions.exclude :search
    config.update.link = false
    config.actions.exclude :show
  end

  def delete_authorized?
    false
  end

end
