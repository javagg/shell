require 'erb'

set :user, "alex"
set :application, "shell"
set :repository, "git://github.com/javagg/shell.git"
set :host, "202.117.46.233"
set :scm, :git
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

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


before "deploy:setup", :db
after "deploy:update_code", "db:symlink"

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    default: &default
    adapter: mysql
    socket: /tmp/mysql.sock
    username: root
    password: 

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
end