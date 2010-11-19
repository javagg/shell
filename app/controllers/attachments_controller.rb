class AttachmentsController < ApplicationController
  def to_label
#    "#{:data_file_name}"
  end
  active_scaffold :attachments do |config|
    config.columns = [:data]
    config.columns[:data].form_ui = :paperclip
    config.actions.exclude :show
    config.actions.exclude :update
  end
end
