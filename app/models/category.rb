# -*- coding: utf-8 -*-
require "acts_as_multiply_category"  
class Category < ActiveRecord::Base
  
  acts_as_multiply_category
    
  #  acts_as_taggable
  
  # чтобы работало move_higher через typus, может сгодится также для AJAX-дерева
  acts_as_list

  # Издержки acts_as_category
  #  belongs_to :parent, :class_name => "Category"
  
  validates_uniqueness_of :name, :case_sensitive=>false #, :scope => [:parent_id]
  validates_presence_of :name
  
  has_many :companies

    
end
