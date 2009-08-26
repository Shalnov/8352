class Branch < ActiveRecord::Base
  acts_as_nested_set

  has_and_belongs_to_many :groups, :class_name => "CompanyGroup"

  named_scope :with_groups, { :include => :groups }
end
