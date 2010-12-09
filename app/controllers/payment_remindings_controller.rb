class PaymentRemindingsController < ApplicationController
  in_place_edit_for :payment_remindings, :remindee_rejected

  def to_label
    "payment_reminding"
  end

  active_scaffold :payment_remindings do |config|
    config.columns = [ :user, :contract, :remindee_rejected ]
    config.columns[:remindee_rejected].form_ui = :select
    config.columns[:remindee_rejected].options = { :options => Shell::Options::shifou_options }
    config.columns[:remindee_rejected].inplace_edit = true

    config.columns[:user].clear_link
    config.columns[:contract].clear_link

    config.list.columns = [:contract, :remindee_rejected]
    config.actions.exclude :create
    config.actions.exclude :delete
    config.actions.exclude :search
    config.update.link = false
    config.actions.exclude :show
  end
end
