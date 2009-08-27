class Branch < ActiveRecord::Base
  acts_as_nested_set

  has_and_belongs_to_many :groups, :class_name => "CompanyGroup"

  named_scope :with_groups, { :include => :groups }
  default_scope :order => "lft"
  
  def move_to_left_or_right(target)
    target = target.is_a?(Fixnum) ? self.class.find(target) : target
    if left > target.right
      move_to_left_of(target)
    else
      move_to_right_of(target)
    end
  end    
end
