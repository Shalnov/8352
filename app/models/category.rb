# -*- coding: utf-8 -*-
class Category < ActiveRecord::Base
  
  extend ActiveSupport::Memoizable 
  
  # TODO Попытаться отключить обновление разных параметров при каждом добавлении категории
  
  acts_as_category
  
  # чтобы работыло move_higher через typus
  acts_as_list
 
  has_many :companies #, :counter_cache => true
  
  validates_uniqueness_of :name, :case_sensitive=>false, :scope => [:parent_id]
  validates_presence_of :name
  
  before_save :nil_hidden
  
  def nil_hidden
    # У меня пока нет скрытых категорий
    self.hidden=nil# unless self.hidden
  end
  
  memoize :children

  class << self 
    extend ActiveSupport::Memoizable 
    
   memoize :roots

  end 
#   define_index do
#     indexes :name
#     indexes description

#     set_property :enable_star => 1
#     set_property :min_infix_len => 1
#   end
  
#  def self.all_for_select(except=nil)
    
#    self.
#     categories = [["-", nil]]
    
#     catego
#     (except.nil? ? sorted : sorted.select{|sorted| sorted.id != except.id }).each do |category|
#         categories << ["#{'-'*(category.ancestors_count || 0)} #{category.name}", category.id]
#     end
#     categories
#  end
  
#   def self.sorted
#     categories = []
#     self.roots.each do |root|
#       add_childs(categories, root)
#     end
#     categories
#   end
  
#   def self.add_childs(categories_array, category)
#     categories_array << category
#     if category.children.size > 0
#       category.children.each do |child|
#         add_childs(categories_array, child)
#       end
#     end
#   end
  
#   def self.update_count
#     Result.count(:include => ['result_category'], :conditions => ["is_updated = :is_updated AND result_categories.category_id IS NULL",
#                                   { :is_updated => true }])
#   end
  
  
  def self.find_or_create(name, parent)
      parent_id = parent.blank? ? nil : parent.id
      Category.find(:first,
                    :conditions=>{ :name=>name, :parent_id=>parent_id },
                    :limit=>1) ||
        Category.create!(:name=>name,
                         :description=>name,
                         :parent_id=>parent_id)
      
  end
  
  
  def self.find_or_create_from_string(str)
    category=nil
    str.split(/\//).map { |x|
      x.strip!
      category=Category.find_or_create(x,category)
    }
    category
  end
  
#   def self.import(unprocessed_cats)
#     return unless unprocessed_cats
#     unprocessed_cats.map { |str| 
#       category=nil
#       str_cats=str.split(/,|;|\//).map { |x|
#         x.strip!
# #        p category
#         category=find_or_create(x,category)
#       }
# #      p "Category", category
# #      p str_cats      
#       category
#     }
#   end
  
end
