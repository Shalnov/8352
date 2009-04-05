class Phone < ActiveRecord::Base
  set_primary_key "number"

  belongs_to :company

  validates_presence_of :number
end
