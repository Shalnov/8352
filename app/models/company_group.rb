class CompanyGroup < ActiveRecord::Base
  has_many :companies, :dependent => :nullify
  has_and_belongs_to_many :branches
  
  validates_presence_of :name

  named_scope :ordered, { :order => "name ASC" }
  named_scope :with_branches, { :include => :branches }
end
