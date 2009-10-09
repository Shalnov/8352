class Premise < ActiveRecord::Base
  belongs_to :street
  has_many :addresses
end
