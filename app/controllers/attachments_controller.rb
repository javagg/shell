class AttachmentsController < ApplicationController
  def to_label
    "#{:data_file_name}"
  end
  
  active_scaffold :attachments do |config|
    config.columns = [:data]

    # no need to show
    config.actions.exclude :show

    # add download link to control download access
    config.action_links.add :download, :label => I18n.t('txt.download')
    config.action_links[:download].type = :member
    config.action_links[:download].popup = true
    config.action_links[:download].security_method = :download_authorized?
  end

  def download
    head(:not_found) and return if (attachment = Attachment.find(params[:id])).nil?
    head(:forbidden) and return unless download_authorized?
    send_file_options = { :type => attachment.data_content_type }

    #    case SEND_FILE_METHOD
    #      when :apache then send_file_options[:x_sendfile] = true
    #      when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
    #    end

    send_file(attachment.data.path, send_file_options )
  end

  def create_authorized?
    permitted_to? :create, :attachments
  end

  def delete_authorized?
    permitted_to? :delete, :attachments
  end

  def update_authorized?
    permitted_to? :update, :attachments
  end

  def download_authorized?
    permitted_to? :read, :attachments
  end
end
