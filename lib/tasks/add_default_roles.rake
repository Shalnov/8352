namespace :db do
  namespace :p8352 do
    desc"Add default roles"
    task :add_default_roles => :environment do
      ["admin", "editor", "reviewer"].each { |role| Role.create :name => role }
    end
  end
end