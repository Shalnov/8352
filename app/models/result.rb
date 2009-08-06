# -*- coding: utf-8 -*-
require "phone_parser"
require "address_parser"

class Result < ActiveRecord::Base
  
  self.establish_connection :grabber
  
  belongs_to :company, :counter_cache => true
  
  belongs_to :source

  belongs_to :result_category
  has_one :category, :through=>:result_category

  include PhoneHelper
  extend ActiveSupport::Memoizable
  
  
    
# ------------------------------------------------------------------------------
    state_machine :state, :initial => :updated do

    event :mark_imported do
      transition :updated => :imported
    end

    event :mark_updated do
      transition :imported => :updated
    end

  end

  # ------------------------------------------------------------------------------
  # Эти статусы имеют значение только если state=imported
  #
  
  state_machine :importer_state, :initial => :none do
    
    before_transition :do => :mark_imported
    
    event :mark_none do
      transition all => :none
    end

    event :mark_ok do
      transition all => :ok
    end

    event :mark_prepared do
      transition all => :prepared
    end

    event :mark_pending do
      transition all => :pending
    end

    event :mark_error do
      transition all => :error
    end

  end
# ------------------------------------------------------------------------------

  

  # Обновленные
  named_scope :updated, { 
    :conditions => { :state => 'updated' },
    :order => :id 
  }
  
  # Готовые к имортированую (все для кого установлены категории
  named_scope :importable, lambda  { |source_id|
    { 
    :include => :result_category,
    :conditions => ["state='updated' and results.source_id=? and result_category_id is not null",
                    source_id]
    }
  }
  
  
    # для typus
  def self.importer_state
    ['none','prepared','ok','pending','error']
  end

  def self.state
    ['updated','imported']
  end

  
  
  def company_fields
    { 
      :name=> self.name,
      :site=> self.site_url,
      :working_time => self.work_time,
      :address => self.address,
      :description => self.other_info,
      :city_id     => self.lookup_city.id,
      :category_id => self.result_category.category_id 
    }
  end

  
  def import_new_company
    # TODO Лочить запись results при 
    self.create_company(self.company_fields)
    self.company.update_phones(self.phones_to_import)
    self.company.tag_list << self.result_category.tag_list.map { |t| t.name }
 #   self.company.save_tags
    self.mark_ok
    self.save!
  end
  
  
  def update_company(company=nil)
    # TODO Лочить запись results при 
    self.company=company if company
    # TODO Обновление и других параметров, помимо телефонов
    self.company.update_phones(self.phones_to_import)
#    p "tag_list #{self.company.id}, #{self.result_category}", self.company.tag_list=self.result_category.tag_list

    self.company.tag_list.add(self.result_category.tag_list.map { |t| t.to_s })
    self.company.save_tags
    self.mark_ok
#    p "tag_list #{self.company.id}",self.company.tag_list
    self.save!
 #   raise 'test'    
  end
  
  
  # Искать город везьде
  def lookup_city
    lookup_city_in_address || lookup_city_in_phones || get_current_city
  end
  
  memoize :lookup_city
  
  
  def lookup_city_in_phones
    return unless self.phones
    city=nil
    self.phones.split(/,|;/).each { |x| 
      x=x.to_s.gsub(/[^0-9]/,'')
      if x.size>=10
        x="7"+x if x.size==10
        city=City.find_by_prefix(x[1..4]) || City.find_by_prefix(x[1..5])
        return if city
      end
    }
    city
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
  
  
  # Собственно импорт компании
  
  def parse_address
    AddressParser.instance.parse(self.address)
  end
  
  def import
    if self.company
      self.update_company()
      return 0
    elsif company = Company.find_by_result(self)
      self.update_company(company)
      return 0
    else
      company=self.import_new_company
      return 1
    end
  end
  
  def phones_to_import
    prefix = (lookup_city_in_address || get_current_city).prefix
    
    phones = (PhoneParser.instance.parse(self.other_info) +
              PhoneParser.instance.parse(self.phones)).each { |p| p.phone=normalize_phone(p.phone,prefix)}

    # return if phones.blank?
    # self.phones.split(/,|;/).map { |x| 
    #   parse_phone(x,prefix)
    # }
  end
  
end
