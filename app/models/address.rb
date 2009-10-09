class Address < ActiveRecord::Base
  belongs_to :company
  belongs_to :city
  belongs_to :premise
  
  serialize  :parsed_address
  serialize  :ymaps
  
  validates_presence_of :city_id, :address
end
