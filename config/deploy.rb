#############################################################
#       Application
#############################################################

set :application, "8352.info"
set :deploy_to, "/home/p8352/#{application}"

#############################################################
#       Settings
#############################################################

default_run_options[:pty] = false
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "development"
#set :rails_env, "production"

#############################################################
#       Servers
#############################################################

set :user, "p8352"
set :domain, "77.240.152.34"
set :port, 444
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#       Git
#############################################################

set :scm, :git
set :branch, "master"
set :repository, "git://github.com/atlancer/8352.git"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the apache config file"
  task :after_update_code do
  
    apache_config = <<-EOF
    <VirtualHost 72.52.205.197:80>
      ServerName #{domain}
      DocumentRoot #{deploy_to}/current/public
      RailsEnv #{rails_env}
    </VirtualHost>
      
    EOF
    
    put apache_config, "#{shared_path}/apache.conf"
    
  end

  # Restart passenger on deploy
#  desc "Restarting mod_rails with restart.txt"
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
  
#  [:start, :stop].each do |t|
#    desc "#{t} task is a no-op with mod_rails"
#    task t, :roles => :app do ; end
#  end
  
  desc "Run this after every successful deployment"
  task :after_default do
    restart_background_fu
  end

end

desc "Restart BackgroundFu daemon"
task :restart_background_fu do
  run "RAILS_ENV=#{rails_env} ruby #{current_path}/script/daemons stop"
  run "RAILS_ENV=#{rails_env} ruby #{current_path}/script/daemons start"
end


#after "deploy:setup", "localize:copy_database_config"

