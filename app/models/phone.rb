class Phone < ActiveRecord::Base
  set_primary_key "number"

  belongs_to :company

  validates_presence_of :number
#  attr_accessible :number, :person, :working_time, :description, :short_code, :department
 
 def id
  number
 end 
end
