set :stages, %w(production preview)
set :default_stage, "preview"

require 'capistrano/ext/multistage'

require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'

set :application, "Knack"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/ilya/public_html"

set :scm_username, "capistrano"
set :scm_password, "KnAcK21586412"
set :user, "root"
set :use_sudo, false

# Start and restart sphinx.
after("deploy:update", "deploy:restart")
after("deploy:create_symlink", "symlink_database_yml")

# Stuff For AirBrake.
require './config/boot'
require 'airbrake/capistrano'

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

task :before_update_code, :roles => [:app] do
  thinking_sphinx.stop
end

task :symlink_sphinx_indexes, :roles => [:app] do
  run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
end

task :symlink_database_yml, :roles => [:app] do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

task :after_update_code, :roles => [:app] do
  symlink_sphinx_indexes
  thinking_sphinx.configure
  thinking_sphinx.start
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
