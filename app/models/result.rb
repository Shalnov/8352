# -*- coding: utf-8 -*-
class Result < ActiveRecord::Base
  include PhoneHelper

  belongs_to :link
  belongs_to :company, :counter_cache => true
  belongs_to :source


  belongs_to :result_category
  has_one :category, :through=>:result_category

  #, :foreign_key => "category_name" #, , :primary_key=> "category_name"  :conditions => ["source_id=?",source_id] 
  
#  before_save :strip_fields

#  named_scope :checked, { :conditions => { :is_checked => true } }
#  named_scope :not_checked, { :conditions => { :is_checked => false } }
  
  named_scope :updated, { :conditions => { :is_updated => true },
                          :order => :id }
  
  
  named_scope :importable, lambda { |source_id|  {
      :include => :result_category,
      :conditions => ["is_updated AND results.source_id=? AND result_categories.id=results.result_category_id", source_id]
      #      :limit => 500
    }
  }

#   def strip_fields
#     self.strip_field!(:name)
#     self.strip_field!(:address)
#     self.strip_field!(:phones)
#     self.strip_field!(:email)
#     self.strip_field!(:site_url)
#     self.strip_field!(:category)
#     self.strip_field!(:work_time)
#   end

#   def strip_field!(field = nil)
#     false #.strip .strip!
#     if self.attribute_names.include?(field.to_s) && 
#        !self[field].nil? && (self[field].mb_chars.length > self.column_for_attribute(field).limit)
#       self.update_attribute field, self[field].mb_chars[0..(self.column_for_attribute(field).limit - 1)].to_s
#     end
#   end
  
  RESULTS_FIELDS = { :name => :name,
    :site => :site_url,
    :working_time => :work_time,
    :address => :address }

  def company_fields
    { 
      :name=> self.name,
      :site=> self.site_url,
      :working_time => self.work_time,
      :address => self.address,
      :category_id => self.result_category.category_id 
    }
  end


  def normalized_phones
    return nil unless self.phones
    pat=/(\d+)\s*(.*)/
    h={}
    self.phones.split(/,|;/).map { |x| 
      x=x.strip.to_s
      r=x.scan(pat)
      if !r.blank?
        phone=normalize_phone(r[0][0])
        if phone
          name=r[0][1]
          h[phone]=name.blank? ? nil : name.to_s.gsub(/\(|\)/,'')
        end
        
      else 
        p "WARN: Bad phone recognize: '#{x}' from #{self.phones}"
      end
    }
    h
  end
  
  def import_new_company
    
    company = self.create_company(self.company_fields)
    company.update_phones(self.normalized_phones)
#    company.save!
    
#    self.company_id=company.id
    self.is_updated=false
    self.save!

    company
  end
  
  def update_company(company=nil)
        
    self.company=company if company
    
        # TODO Пока ничего кроме телефонов не обновляем!
    self.company.update_phones(self.normalized_phones)    

    
    self.is_updated=false
    self.save!

    company
  end
  
end
