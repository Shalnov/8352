namespace :db do
  namespace :p8352 do
    desc"Add default users"
    task :add_default_users => :environment do
      r = Role.find_by_name 'admin'
      if r
        u = User.create :login => 'admin',
                        :email => 'username@some-domain-name.com',
                        :password => 'admin123',
                        :password_confirmation => 'admin123'
        u.activate!
        u.roles << r
      else
        raise "role 'admin' not found, please execute 'rake db:p8352:add_default_roles' first"
      end
    end
  end
end
