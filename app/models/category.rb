class Category < ActiveRecord::Base
  acts_as_category
  
  has_many :companies
  
  validates_presence_of :name
  
  define_index do
    indexes :name
    indexes description

    set_property :enable_star => 1
    set_property :min_infix_len => 1
  end
  
  def self.all_for_select(except=nil)
    categories = [["-", nil]]
    (except.nil? ? sorted : sorted.select{|sorted| sorted.id != except.id }).each do |category|
        categories << ["#{'-'*category.ancestors_count} #{category.name}", category.id]
    end
    categories
  end
  
  def self.sorted
    categories = []
    self.roots.each do |root|
      add_childs(categories, root)
    end
    categories
  end
  
  def self.add_childs(categories_array, category)
    categories_array << category
    if category.children.size > 0
      category.children.each do |child|
        add_childs(categories_array, child)
      end
    end
  end
  
end
