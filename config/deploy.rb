$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'erb'
require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-1.8.7-p302'

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :host, "61.236.244.74"
set :user, "alex"
set :rvm_type, :user
set :application, "shell"
set :repository, "git@github.com:javagg/shell.git"
set :scm, :git
set :branch, "master"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache

role :web, host.to_s
role :app, host.to_s
role :db, host.to_s, :primary => true

after "deploy:setup", "deploy:chown_for_deploy_user", "db:generate_database_yml", "web:setup"
after "deploy:update_code", "db:link_to_database_yml"
before "web:setup", "web:generate_a2site_config"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :chown_for_deploy_user do
    run "#{try_sudo} chown #{user}:#{user} -R #{deploy_to}"
  end
end

namespace :db do
  desc "Create database yaml in shared path"
  task :generate_database_yml, :roles => :app do
    db_options = {
      "adapter" => "mysql",
      "database" => "#{application}_production",
      "encoding" => "utf8",
      "username" => "root",
      "password" => "",
      "socket" => "/var/run/mysqld/mysqld.sock"
    }
    config_options = { "production" => db_options }.to_yaml

    run "mkdir -p #{shared_path}/config"
    put config_options, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :link_to_database_yml, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml
      #{release_path}/config/database.yml"
  end

  desc "Populate database with preconfigure data"
  task :seed_database, :roles => :db do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end

  desc "Create database on server"
  task :create_database, :roles => :db do
    run "cd #{current_path}; rake db:create RAILS_ENV=production"
  end

  desc "Drop database on server"
  task :drop_database, :roles => :db do
    run "cd #{current_path}; rake db:drop RAILS_ENV=production"
  end

  desc "Start the Mysql processes on the app server."
  task :start, :roles => :web do
    sudo "start mysql" end

  desc "Restart the Mysql processes on the app server by starting and stopping the cluster."
  task :restart , :roles => :web do
    sudo "restart mysql"
  end

  desc "Stop the Mysql processes on the app server."
  task :stop , :roles => :web do
    sudo "stop mysql"
  end
end

set :web_port, "80"
set :web_name, "shell-apache-site"

namespace :web do
  desc "Configure Apache2"
  task :setup, :roles => :web do
    run "cd #{current_path}"
    sudo "cp #{current_path}/deploy/passenger.conf /etc/apache2/mods-available/"
    sudo "cp #{current_path}/deploy/passenger.load /etc/apache2/mods-available/"
    sudo "a2enmod passenger"
    sudo "cp #{shared_path}/config/#{web_name} /etc/apache2/sites-available/"
    sudo "a2dissite default"
    sudo "a2ensite #{web_name}"
  end

  desc "Generate apache2 site config file"
  task :generate_a2site_config, :roles => :web do
    site_config = ERB.new <<-EOF
<VirtualHost *:#{web_port}>
  ServerName loaclhost
  DocumentRoot #{current_path}/public
  RailsEnv production
  <Directory #{current_path}/public>
    AllowOverride all
    Options -MultiViews
  </Directory>
</VirtualHost>
    EOF
    run "mkdir -p #{shared_path}/config"
    put site_config.result, "#{shared_path}/config/#{web_name}"
  end

  desc "Start apache2 on the app server."
  task :start, :roles => :web do
    sudo "/etc/init.d/apache2 start" end
 
  desc "Restart the Apache2 processes on the app server by starting and stopping the cluster."
  task :restart , :roles => :web do
    sudo "/etc/init.d/apache2 restart"
  end
 
  desc "Stop the Apache2 processes on the app server."
  task :stop , :roles => :web do
    sudo "/etc/init.d/apache2 stop"
  end
end
