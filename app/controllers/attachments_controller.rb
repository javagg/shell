class AttachmentsController < ApplicationController
  active_scaffold :attachment do |config|
    config.columns = [:data]
  end
end
