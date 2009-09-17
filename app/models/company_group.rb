class CompanyGroup < ActiveRecord::Base
  has_many :companies, :dependent => :nullify, :include=>:company_group
  has_and_belongs_to_many :branches
  
  has_many :results_to_company_groups
  
  validates_presence_of :name

  named_scope :ordered, { :order => "name ASC" }
  named_scope :with_branches, { :include => :branches }
  
  def long_name
    name + '(' + branches.map(&:name).join(',') +')'
  end

  def breadcrumb
    self.branches.collect do |branch|
      branch.breadcrumb + [self]
    end
  end
  
end
