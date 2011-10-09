# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.12' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

RAILS_DEFAULT_LOGGER = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log", "daily")
Rails::Initializer.run do |config|
  config.gem "shoulda", :version => '2.11.3'
  config.gem "app_config", :version => '0.7.1'
  config.gem "spreadsheet", :version => "0.6.5.7"
  #config.gem "passenger", :version => "3.0.7"
  config.gem "capistrano", :version => "2.6.0"
  config.gem "mysql", :version => "2.8.1"
  
  config.time_zone = 'UTC'
  config.action_controller.session_store = :active_record_store
  config.active_record.colorize_logging = false
end

require 'app_config'
AppConfig.setup do |app_config|
  app_config[:storage_method] = :yaml
  app_config[:env] = "#{RAILS_ENV}"
  app_config[:path] = "#{RAILS_ROOT}/config/app_config.yml"
end

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

ActionMailer::Base.sendmail_settings =  {
  :location       => '/usr/sbin/sendmail',
  :arguments      => '-i -t'
}
