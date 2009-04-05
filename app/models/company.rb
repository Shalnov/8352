class Company < ActiveRecord::Base
  belongs_to :category

  has_many :phones, :dependent => :destroy
  has_many :emails, :dependent => :destroy
  has_many :tags,   :as => :taggable, :dependent => :destroy

  validates_presence_of :name, :full_name
end
