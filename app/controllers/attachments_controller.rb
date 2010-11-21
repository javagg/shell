class AttachmentsController < ApplicationController
  def to_label
#    "#{:data_file_name}"
  end
  active_scaffold :attachments do |config|
#    config.action_links.add 'download', :label => 'Download'

    config.columns = [:data]
    config.columns[:data].form_ui = :paperclip
    config.columns[:data].options = {}
    config.actions.exclude :show
    config.actions.exclude :update
  end


  def download
    head(:not_found) and return if (attachment = self.find_by_id(params[:id])).nil?
    #    head(:forbidden) and return unless attachment.downloadable?(current_user)

#    path = attachment.data.url(params[:style])
    head(:bad_request) and return unless File.exist?(path) && params[:format].to_s == File.extname(path).gsub(/^\.+/, '')

#    send_file_options = { :type => File.mime_type?(path) }

#    case SEND_FILE_METHOD
#      when :apache then send_file_options[:x_sendfile] = true
#      when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
#    end

    send_file(attachment.data.url, :type => attachment.data_content_type, :disposition => 'inline')
  end
end
