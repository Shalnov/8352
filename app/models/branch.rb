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

  def self.each_with_level_and_groups(objects)
    path = [nil]
    objects.each do |o|
      if o.parent_id != path.last
        # we are on a new level, did we decent or ascent?
        if path.include?(o.parent_id)
          # remove wrong wrong tailing paths elements
          path.pop while path.last != o.parent_id
        else
          path << o.parent_id
        end
      end
      yield(o, path.length - 1)
    end
  end
end
