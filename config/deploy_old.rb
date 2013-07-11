require "bundler/capistrano"
set :user, 'rail_admin'
set :application, "sbase"
set :repository,  "https://github.com/jlspangl/sbase.git"

set :scm, :git # You can FuZset :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
server "sbase.larc.nasa.gov" , :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

after 'deploy:update_code', 'deploy:migrate'

set :deploy_to, :remote_cache
set :deploy_via, :remote_cache


#resources:  https://gist.github.com/jrochkind/2161449

