class ApplicationController < ActionController::Base
  layout 'site'
  before_filter :set_locale

  helper :all
  protect_from_forgery
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  before_filter :set_current_user
  
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
  rescue  Exception => err
    logger.error err
    flash[:notice] = "#{I18n.locale} translation not available"
    I18n.load_path -= [locale_path]
    I18n.locale = session[:locale] = I18n.default_locale
  end

  private

  def set_mailer_url_options
    begin
      request = self.request
      ActionController::UrlWriter.module_eval do
        @old_default_url_options = default_url_options.clone
        default_url_options[:host] = request.host
        default_url_options[:port] = request.port unless request.port == 80
        protocol = /(.*):\/\//.match(request.protocol)[1] if request.protocol.ends_with?("://")
        default_url_options[:protocol] = protocol
      end
      yield
    ensure
      ActionController::UrlWriter.module_eval do
        default_url_options[:host] = @old_default_url_options[:host]
        default_url_options[:port] = @old_default_url_options[:port]
        default_url_options[:protocol] = @old_default_url_options[:protocol]
      end
    end
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
      redirect_to account_url
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



  protected
  
  # declarative_authorization tell you why
  def permission_denied
    respond_to do |format|
      flash[:error] = I18n.t 'txt.unauthorized_access'
      format.html { redirect_to root_url }
      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
    end
  end
end
