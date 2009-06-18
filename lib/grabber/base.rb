module Grabber
  class Base

#    include BackgroundFu::WorkerMonitoring

    attr_reader :number_of_attempts

    def initialize
      @number_of_attempts = 3
    end

    def run(source_id)
      Source.find(source_id) if source_id
    end

  end
end

