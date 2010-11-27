class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user

  before_filter :set_locale, :set_mailer_url_options
  before_filter :set_current_user

  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  ActiveScaffold.set_defaults do |config|
    config.theme = :blue
    config.ignore_columns.add [:created_at, :updated_at, :id]
    config.list.empty_field_text = I18n.t 'active_scaffold.column_is_null'
  end

  protected
  
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
  rescue  Exception => err
    logger.error err
    flash[:notice] = "#{I18n.locale} translation not available"
    I18n.load_path -= [locale_path]
    I18n.locale = session[:locale] = I18n.default_locale
  end

  protected

  # declarative_authorization tell you why
  def permission_denied
    respond_to do |format|
      flash[:error] = I18n.t 'txt.unauthorized_access'
      format.html { redirect_back_or_default root_url }
      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
    end
  end

  private

  def set_mailer_url_options
#    ActionMailer::Base.default_url_options[:host] = request.host_with_port

    #    begin
    #      request = self.request
    #      ActionController::UrlWriter.module_eval do
    #        @old_default_url_options = ActionMailer::Base::default_url_options.clone
    #        ActionMailer::Base::default_url_options[:host] = request.host
    #        ActionMailer::Base::default_url_options[:port] = request.port unless request.port == 80
    #        protocol = /(.*):\/\//.match(request.protocol)[1] if request.protocol.ends_with?("://")
    #        ActionMailer::Base::default_url_options[:protocol] = protocol
    #      end
    #    ensure
    #      ActionController::UrlWriter.module_eval do
    #        ActionMailer::Base::default_url_options[:host] = @old_default_url_options[:host]
    #        ActionMailer::Base::default_url_options[:port] = @old_default_url_options[:port]
    #        ActionMailer::Base::default_url_options[:protocol] = @old_default_url_options[:protocol]
    #      end
    #    end
  end

  # let declarative_authorization works with authlogic
  def set_current_user
    Authorization.current_user = current_user
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = t 'txt.logged_in_to_access'
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = t 'txt.logged_out_to_access'
      redirect_back_or_default root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end