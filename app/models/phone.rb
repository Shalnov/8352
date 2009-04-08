class Phone < ActiveRecord::Base

  belongs_to :company

  validates_presence_of :number

end
