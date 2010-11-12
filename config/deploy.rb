require 'erb'

set :user, "alex"
set :application, "shell"
set :repository,  "git://github.com/javagg/shell.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "202.117.46.233"                          # Your HTTP server, Apache/etc
role :app, "202.117.46.233"                          # This may be the same as your `Web` server
role :db,  "202.117.46.233", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

before "deploy:setup", :db
after "deploy:update_code", "db:symlink"

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    default: &default
    adapter: mysql
    socket: /tmp/mysql.sock
    username: #{user}
    password: #{password}

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