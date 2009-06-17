class Source < ActiveRecord::Base
  has_many :links
  has_many :results, :through => :links
  
  has_many :jobs

  after_create :update_from_grabber_module

  def update_from_grabber_module
    require "Grabber::#{self.grabber_module}".underscore
    grabber = "Grabber::#{self.grabber_module}".constantize.new
    self.update_attributes :target_url => grabber.target_url,
                           :description => grabber.description
  end

end
