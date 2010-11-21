ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.default_url_options = { :host => "localhost", :port => 3000 }
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.sohu.com",
  :port => 25,
  :domain => "sohu.com",
  :authentication => :login,
  :user_name => "forshell12345",
  :password => "1234567",
}