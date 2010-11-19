require 'erb'

default_run_options[:pty] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

set :user, "alex"
set :application, "shell"
set :repository, "git://github.com/javagg/shell.git"
set :scm, :git
set :branch, "master"

set :deploy_to, "/home/#{user}/#{application}"
#set :use_sudo, true
#set :deploy_via, :remote_cache
set :default_environment, {
  'PATH' => "/home/alex/.rvm/gems/ruby-1.8.7-p302/bin:/home/alex/.rvm/gems/ruby-1.8.7-p302@global/bin:/home/alex/.rvm/rubies/ruby-1.8.7-p302/bin:/home/alex/.rvm/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.8.7',
  'GEM_HOME' => '/home/alex/.rvm/rubies/ruby-1.8.7-p302/lib/ruby/gems/1.8',
  'GEM_PATH' => '/home/alex/.rvm/gems/ruby-1.8.7-p302:/home/alex/.rvm/gems/ruby-1.8.7-p302@global'
}


#ssh_options[:forward_agent] = true

set :host, "202.117.46.233"

role :web, host
role :app, host
role :db, host, :primary => true


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
#require 'rvm/capistrano'
#set :rvm_ruby_string, 'ruby-1.8.7-p302'

after "deploy:setup", "db:generate_database_yaml"
after "deploy:update_code", "db:symlink"
#after "deploy:update_code", "web:setup"
before "deploy:migrate", "db:create"
after "deploy:migrate", "db:seed"

namespace :db do
  desc "Create database yaml in shared path"
  task :generate_database_yaml do
    db_config = ERB.new <<-EOF
defaults: &defaults
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: #{application}_production
  pool: 5
  username: root
  password:
  socket: /var/run/mysqld/mysqld.sock

development:
  database: #{application}_development
  <<: *defaults

test:
  database: #{application}_test
  <<: *defaults

production:
  database: #{application}_production
  <<: *defaults
EOF
    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml
      #{release_path}/config/database.yml"
  end

  desc "Populate database with preconfigure data"
  task :seed, :roles => :db do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end

  desc "Create database on server"
  task :create, :roles => :db do
    run "cd #{current_path}; rake db:create RAILS_ENV=production"
  end

  desc "Drop database on server"
  task :drop, :roles => :db do
    run "cd #{current_path}; rake db:drop RAILS_ENV=production"
  end
end

set :port, "80"
set :site_name, "shell-apache-site"

#namespace :web do
#  desc "Configure Apache2"
#  task :setup, :roles => :web do
#    run "cd #{current_path}"
#    sudo "cp #{current_path}/deploy/passenger.conf /etc/apache2/mods-available/"
#    sudo "cp #{current_path}/deploy/passenger.load /etc/apache2/mods-available/"
#    sudo "a2enmod passenger"
#    sudo "cp #{current_path}/deploy/#{site_name} /etc/apache2/sites-available/"
#    sudo "a2dissite default"
#    sudo "a2ensite #{site_name}"
#  end
#
#  desc "Generate apache2 site config file"
#  task :generate_a2site, :roles => :web do
#    site_config = ERB.new <<-EOF
#<VirtualHost *:#{port}>
#  ServerName loaclhost
#  DocumentRoot #{current_path}/public
#  RailsEnv production
#  <Directory #{current_path}/public>
#    AllowOverride all
#    Options -MultiViews
#  </Directory>
#</VirtualHost>
#EOF
#    run "mkdir -p #{shared_path}/config"
#    put site_config.result, "#{shared_path}/config/#{site_name}"
#  end
#end