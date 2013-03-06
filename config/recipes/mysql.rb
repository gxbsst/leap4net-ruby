
namespace :mysql do
  desc "Install the latest stable release of mysql."
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} apt-get -y install mysql-server mysql-client libmysqlclient-dev"
  end
  after "deploy:install", "mysql:install"

  #desc "Symlink the database.yml file into latest release"
  #task :symlink, roles: :app do
  #  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  #end
  #after "deploy:finalize_update", "mysql:symlink"
end
