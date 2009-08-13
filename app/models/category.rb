# -*- coding: utf-8 -*-
class Category < ActiveRecord::Base
  
  acts_as_multiply_category
  
  has_many :companies
  
  #  acts_as_taggable
  
  # чтобы работыло move_higher через typus
  acts_as_list

  # Издержки acts_as_category
  #  belongs_to :parent, :class_name => "Category"
  
  validates_uniqueness_of :name, :case_sensitive=>false #, :scope => [:parent_id]
  validates_presence_of :name
  
    
end
