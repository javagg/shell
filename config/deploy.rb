require 'erb'

set :user, "alex"
set :application, "shell"
set :repository, "git://github.com/javagg/shell.git"
set :host, "202.117.46.233"
set :scm, :git
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, true

role :web, host                         # Your HTTP server, Apache/etc
role :app, host                   # This may be the same as your `Web` server
role :db, host, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

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

set :default_environment, {
  'PATH' => "/home/alex/.rvm/gems/ruby-1.8.7-p302/bin:/home/alex/.rvm/gems/ruby-1.8.7-p302@global/bin:/home/alex/.rvm/rubies/ruby-1.8.7-p302/bin:/home/alex/.rvm/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.8.7',
  'GEM_HOME' => '/home/alex/.rvm/rubies/ruby-1.8.7-p302/lib/ruby/gems/1.8',
  'GEM_PATH' => '/home/alex/.rvm/gems/ruby-1.8.7-p302:/home/alex/.rvm/gems/ruby-1.8.7-p302@global'
}


#before "deploy:setup", :db
after "deploy:update_code", "web:setup"
before "deploy:migrate", "db:create"
after "deploy:migrate", "db:seed"

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    default: &default
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
    <<: *default

    test:
    database: #{application}_test
    <<: *default

    production:
    database: #{application}_production
    <<: *default
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
  task :seed, :roles => :app do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end

  desc "Populate database with preconfigure data"
  task :create, :roles => :app do
    run "cd #{current_path}; rake db:create RAILS_ENV=production"
  end
end
namespace :web do
  desc "Configure Apache2"
  task :setup, :roles => :web do
    run "cd #{current_path}"
    run "cp deploy/passenger.conf /etc/apache2/mods-available/"
    run "cp deploy/passenger.load /etc/apache2/mods-available/"
    run "a2enmod passenger"
    run "cp deploy/shell-apache-site /etc/apache2/sites-available"
    run "a2ensite shell-apache-site"
  end
end