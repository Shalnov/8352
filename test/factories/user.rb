Factory.define :user do |u|
  u.sequence(:login) {|n| "vasia_#{n}" }
  u.crypted_password { User.password_digest('123456', User.make_token) }
  u.sequence(:email) {|n| "person#{n}@example.com" }
end
