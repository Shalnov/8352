# -*- coding: utf-8 -*-
class ResultsToCompanyGroup < ActiveRecord::Base
    
  self.establish_connection :grabber
  
#  acts_as_taggable
  
  belongs_to :company_group
  belongs_to :source
  has_many :results, :dependent=>:nullify
  
  validates_uniqueness_of :category_name, :case_sensitive=>false, :scope => [:source_id]
  validates_presence_of :category_name

  after_save :update_results
#  before_destroy :update_results
  
  # TODO Проверять на обязательное присутствие одного из primary тэгов
  # или, может быть, на один из тэгов присутствующий в category
  
  def name
    self.category_name
  end
  
  def update_results
    Result.
      update_all({
                   :company_group_id=>self.company_group_id,
                 },
                 {
                   :category_name=>self.category_name
                 })
  end
  

end
