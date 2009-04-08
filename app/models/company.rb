class Company < ActiveRecord::Base
  belongs_to :category, :counter_cache => true

  has_many :phones,   :dependent => :destroy
  has_many :emails,   :dependent => :destroy
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags,     :through => :taggings

  validates_presence_of :name, :full_name
  
  accepts_nested_attributes_for :phones, :allow_destroy => true,
                                :reject_if => proc { |phone| phone['number'].blank? }
  accepts_nested_attributes_for :emails, :allow_destroy => true
  
end
