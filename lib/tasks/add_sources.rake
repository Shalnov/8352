namespace :db do
  namespace :p8352 do
    desc"Add sources"
    task :add_sources => :environment do
      Dir["#{RAILS_ROOT}/lib/grabber/*"].each { |file| require file }
      (Grabber.constants - ["Base"] - Source.all.map{ |source| source.grabber_module }).each do |grabber_module|
        Source.create :grabber_module => grabber_module
      end
    end
  end
end