class Processing

#  include BackgroundFu::WorkerMonitoring

  def run_grabber(source_id)
    source = Source.find(source_id)
    require "Grabber::#{source.grabber_module}".underscore
    grabber = "Grabber::#{source.grabber_module}".constantize.new
    grabber.run
  end

end
