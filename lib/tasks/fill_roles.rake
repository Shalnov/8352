namespace :db do
  desc"Fill roles table."
  task :fill_roles => :environment do
    ["admin", "editor", "reviewer"].each do |role|
      Role.create(:name => role)
    end
  end
end