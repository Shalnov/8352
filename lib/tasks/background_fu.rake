namespace :background_fu do
  desc "Start BackgroundFu daemon"
  task :start do
    system "ruby ./script/daemons start"
  end

  desc "Stop BackgroundFu daemon"
  task :stop do
    system "ruby ./script/daemons stop"
  end

#  desc "Restart BackgroundFu daemon"
#  task :restart do
#    stop
#    start
#  end
end
