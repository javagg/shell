class AttachmentsController < ApplicationController
  def to_label
    "#{:data_file_name}"
  end
  
  active_scaffold :attachments do |config|
    config.columns = [:data]

    # no need to show
    config.actions.exclude :show
    config.action_links.add :download, :label => I18n.t('txt.download')
    config.action_links[:download].type = :member
    config.action_links[:download].popup = true
    config.action_links[:download].security_method = :download_authorized?
  end

  def download
    head(:not_found) and return if (attachment = Attachment.find(params[:id])).nil?
    head(:forbidden) and return unless download_authorized?
    filename = File.basename(Iconv.iconv("gb2312", "utf-8", attachment.data.path)[0])
    send_file_options = { :type => attachment.data_content_type, :filename => filename }
    send_file(attachment.data.path, send_file_options)
  end

  def download_authorized?
    true
  end

  include Shell::CreationAuthorization
end
