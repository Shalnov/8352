class Branch < ActiveRecord::Base
  acts_as_nested_set

  has_and_belongs_to_many :groups, :class_name => "CompanyGroup", :order => "name ASC"

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
  
  def companies
    c=[]
    gs=groups
    descendants.map { |d| 
      gs=gs+d.groups
    }
    gs.map { |g| 
      c=c+g.companies
    }
    c
  end

  def breadcrumb
    self.root? ? [self] : self.parent.breadcrumb + [self]
  end

end
