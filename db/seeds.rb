# Add default roles
Role.create [{ :name => 'admin' }, { :name => 'moderator' }, { :name => 'user' }]

# Add default admin
user = User.create :email => 'admin@domain.abc',
                   :password => 'admin123',
                   :password_confirmation => 'admin123'
user.activate!
user.has_role! :admin

