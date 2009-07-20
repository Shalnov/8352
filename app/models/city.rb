class City < ActiveRecord::Base
  
  
  has_many :companies
  
  validates_presence_of :name, :prefix
  validates_uniqueness_of  :name
  validates_format_of   :prefix, :with => /^7\d+$/
  
  before_save :capitalize_name
  
  def capitalize_name
    self.name=self.name.mb_chars.capitalize.to_s
  end
  
end
