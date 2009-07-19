# -*- coding: utf-8 -*-
class Result < ActiveRecord::Base
  include PhoneHelper
  extend ActiveSupport::Memoizable

  belongs_to :link
  belongs_to :company, :counter_cache => true
  belongs_to :source


  belongs_to :result_category
  has_one :category, :through=>:result_category
  
  named_scope :updated, { :conditions => { :is_updated => true },
                          :order => :id }
  
  
  named_scope :importable, lambda { |source_id|  {
      :include => :result_category,
      :conditions => ["is_updated AND results.source_id=? AND result_categories.id=results.result_category_id", source_id]
      #      :limit => 500
    }
  }
  

  def company_fields
    { 
      :name=> self.name,
      :site=> self.site_url,
      :working_time => self.work_time,
      :address => self.address,
      :description => self.other_info,
      :category_id => self.result_category.category_id 
    }
  end

  
  def import_new_company
    
    self.create_company(self.company_fields)
    
    self.company.update_phones(self.normalized_phones)
    
    self.is_updated=false
    self.save!
  end
  
  
  def update_company(company=nil)
        
    self.company=company if company
    
    # TODO Обновление и других параметров, помимо телефонов
    
    self.company.update_phones(self.normalized_phones)

    self.is_updated=false
    self.save!
  end
  
  def lookup_city_in_address
    return if self.address.blank?
    city=nil
    self.address.split(/\W+/).each { |e| 
      
      # TODO Искать case insensetive city
      city=City.find_by_name(e.mb_chars.capitalize.to_s)
      return city if city
    }
    city
  end
  
  memoize :lookup_city_in_address
  
  def normalized_phones
    return if self.phones.blank?
    np=[]
    self.phones.split(/,|;/).each { |x| 
      p=parse_phone(x,lookup_city_in_address)
      np << p if p
    }
    np
  end
  
end
