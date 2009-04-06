namespace :db do
  desc"Set specified user admin role."
  task :make_admin_by_login => :environment do

    raise "usage: rake db:make_admin_by_login login=vasia" unless ENV.include?("login")
    
    u = User.find_by_login(ENV['login'])
    raise "user with login '#{ENV['login']}' not found" if u.nil?
    
    r = Role.find_by_name("admin")
    raise "role 'admin' not found, please execute 'rake db:fill_roles' first" if r.nil?
    
    u.roles << r
    
  end
end