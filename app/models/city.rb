# -*- coding: utf-8 -*-
class City < ActiveRecord::Base
  
  
  has_many :companies
  
  validates_presence_of :name, :prefix, :ctype
  validates_uniqueness_of  :name
  validates_format_of   :prefix, :with => /^7\d\d\d+$/
  
  before_save :capitalize_name
  
  def capitalize_name
    self.name=self.name.mb_chars.capitalize.to_s
  end
  
  
  def self.ctype
    ['город','село','поселок','деревня']
  end
  
  
end
