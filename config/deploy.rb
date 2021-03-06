#require "bundler/capistrano"
#
### !!!! DON'T FORGET SET TMP PERMISSION
#
## Add RVM's lib directory to the load path.
##$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
##set :bundle_cmd, 'source $HOME/.bash_profile && bundle'
## Load RVM's capistrano plugin.....
##require "rvm/capistrano"
#
#
## #set :bundle_cmd, '
## # Load RVM's capistrano plugin.....
## require "
#set :rvm_ruby_string, '1.9.2'
#set :rvm_type, :user  # Don't use system-wide RVM
##set :rvm_type, :user
#
#
#set :deploy_via, :remote_cache
#
#set :application, "Leap4net"
#
##set :default_environment, {
##'LANG' => 'en_US.UTF-8'
##}
#
#if ENV['RAILS_ENV'] =='production'
#  #server "www.coopertire.com.cn", :web, :app, :db, primary: true
#  server "vpn", :web, :app, :db, primary: true
#  set :repository,  "git://github.com/gxbsst/leap4net-ruby.git"
#  # set :deploy_to, "/srv/rails/coopertire_deploy"
#  set :deploy_to, "/srv/rails/leap4net"
#  set :user, "root"
#else
#  server "rails", :web, :app, :db, primary: true
#  set :repository,  "git://github.com/gxbsst/leap4net-ruby.git"
#  set :deploy_to, "/srv/rails/leap4net"
#  set :user, "rails"
#end
#
#set :scm, :git
## Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#
## role :web, "aries.sidways.lab"                          # Your HTTP server, Apache/etc
## role :app, "aries.sidways.lab"                          # This may be the same as your `Web` server
## role :db,  "aries.sidways.lab", :primary => true # This is where Rails migrations will run
## role :db,  "your slave db-server here"
#
##set :user, "rails"
## set :user, "root"
#
#set :use_sudo, false
#
#set :branch, "master"
#
#default_run_options[:pty] = true
#ssh_options[:forward_agent] = true
#
##after "deploy", "deploy:cleanup" # keep only the last 5 releases
#
#
## if you're still using the script/reaper helper you will need
## these http://github.com/rails/irs_process_scripts
#
## If you are using Passenger mod_rails uncomment this:
#namespace :deploy do
#  task :start do ; end
#  task :stop do ; end
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#  end
#
#  task :setup_config, roles: :app do
#    # sudo "ln -nfs #{current_path}/config/apache.conf /etc/apache2/sites-available/#{application}"
#    run "mkdir -p #{shared_path}/config"
#    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
#    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
#    put File.read("config/database.yml.mysql"), "#{shared_path}/config/database.yml"
#    put File.read("config/alipay.yml.example"), "#{shared_path}/config/alipay.yml"
#    put File.read("config/paypal.yml.example"), "#{shared_path}/config/paypal.yml"
#    put File.read("config/vpn_password.example"), "#{shared_path}/config/vpn_password"
#    puts "Now edit the config files in #{shared_path}."
#    # photos
#    # run "mkdir -p /srv/rails/coopertire_stuff/system"
#  end
#
#  after "deploy:setup", "deploy:setup_config"
#
#  task :symlink_config, roles: :app do
#    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#    run "ln -nfs #{shared_path}/config/alipay.yml #{release_path}/config/alipay.yml"
#    run "ln -nfs #{shared_path}/config/paypal.yml #{release_path}/config/paypal.yml"
#    run "ln -nfs #{shared_path}/config/vpn_password #{release_path}/config/vpn_password"
#    #   run "ln -nfs #{shared_path}/config/database.yml  /srv/rails/cooper/releases/20121205032322/config/database.yml"
#    # run "ln -nfs /srv/rails/coopertire_stuff/system #{release_path}/public/system"
#  end
#  after "deploy:finalize_update", "deploy:symlink_config"
#
#
#end


require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/mysql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "199.68.199.216", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "leap4net"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git://github.com/gxbsst/leap4net-ruby.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :setup_config, roles: :app do
    # sudo "ln -nfs #{current_path}/config/apache.conf /etc/apache2/sites-available/#{application}"
    run "mkdir -p #{shared_path}/config"
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    put File.read("config/database.yml.mysql"), "#{shared_path}/config/database.yml"
    put File.read("config/alipay.yml.example"), "#{shared_path}/config/alipay.yml"
    put File.read("config/paypal.yml.example"), "#{shared_path}/config/paypal.yml"
    put File.read("config/vpn_password.example"), "#{shared_path}/config/vpn_password"
    puts "Now edit the config files in #{shared_path}."
    # photos
    # run "mkdir -p /srv/rails/coopertire_stuff/system"
  end

  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/alipay.yml #{release_path}/config/alipay.yml"
    run "ln -nfs #{shared_path}/config/paypal.yml #{release_path}/config/paypal.yml"
    run "ln -nfs #{shared_path}/config/vpn_password #{release_path}/config/vpn_password"
    #   run "ln -nfs #{shared_path}/config/database.yml  /srv/rails/cooper/releases/20121205032322/config/database.yml"
    # run "ln -nfs /srv/rails/coopertire_stuff/system #{release_path}/public/system"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  task :update_crontab, :roles => :app do
    run "cd #{deploy_to}/current && whenever --update-crontab #{application}"
  end

  desc "rake assets:precompile"
  task "assets_precompile", :roles => :app do
    run("cd #{deploy_to}/current && /usr/bin/env rake assets:precompile RAILS_ENV=production")
  end

end
