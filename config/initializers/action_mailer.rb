ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options = { :host => AppConfig['app_domain'], :port => AppConfig['app_port'] }
ActionMailer::Base.smtp_settings = {
  :address => AppConfig['smtp_address'],
  :port => AppConfig['smtp_port'],
  :domain => AppConfig['smtp_domain'],
  :authentication =>  :login,
  :user_name =>  AppConfig['smtp_user_name'],
  :password => AppConfig['smtp_password']
}