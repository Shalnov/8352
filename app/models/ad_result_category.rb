# -*- coding: utf-8 -*-
class AdResultCategory < ActiveRecord::Base
  
  self.establish_connection :grabber
  
#  acts_as_taggable
  
  belongs_to :category
  belongs_to :source
  has_many :ad_results, :dependent=>:nullify
  
  validates_uniqueness_of :category_name, :case_sensitive=>false, :scope => [:source_id]
  validates_presence_of :category_name

  after_save :update_results
  before_destroy :update_results
  
  # TODO Проверять на обязательное присутствие одного из primary тэгов
  # или, может быть, на один из тэгов присутствующий в category
  
  def name
    self.category_name
  end
  
  def update_results
    AdResult.
      update_all({
                   :result_category_id=>self.id,
                   :state=>'updated'
                 },
                 {
                   :category_name=>self.category_name
                 })
  end
  
end