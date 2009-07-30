# -*- coding: utf-8 -*-
class Result < ActiveRecord::Base
  
  self.establish_connection :grabber
  
  belongs_to :company, :counter_cache => true
  
  belongs_to :source

  belongs_to :result_category
  has_one :category, :through=>:result_category

  include PhoneHelper
  extend ActiveSupport::Memoizable
  
#  acts_as_state_machine :initial=>:updated, :column=>'state'
  
  include AASM
  
  aasm_column :state
  
  aasm_initial_state :updated
  aasm_state :updated
  aasm_state :pending
  aasm_state :imported
  aasm_state :partly_imported
  
   
  # Запись обновилась из источника
  aasm_event :set_updated do
    transitions :to => :updated, :from => [:imported,:hunged]
    #, :from => [:importef,]
  end
  
  # Запись удачно импортирована
  aasm_event :set_imported do
    transitions :to => :imported, :from => [:updated,:pending]
  end
  
  # Запись импортирована, но частично (уже есть такая компания)
  aasm_event :set_partly_imported do
    transitions :to => :partly_imported, :from => [:updated,:pending]
  end
  
  # Запись требует вмешательства оператора
  aasm_event :set_pending do
    transitions :to => :pending, :from => [:updated]
  end

  
  
  

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
  def self.state
    ['updated','pending','imported','partly_imported']
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
    self.company.update_phones(self.normalized_phones)
    self.company.tag_list << self.result_category.tag_list.map { |t| t.name }
 #   self.company.save_tags
    self.set_imported
    self.save!
  end
  
  
  def update_company(company=nil)
    # TODO Лочить запись results при 
    self.company=company if company
    # TODO Обновление и других параметров, помимо телефонов
    self.company.update_phones(self.normalized_phones)
#    p "tag_list #{self.company.id}, #{self.result_category}", self.company.tag_list=self.result_category.tag_list

    self.company.tag_list.add(self.result_category.tag_list.map { |t| t.to_s })
    self.company.save_tags
    self.set_partly_imported
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
  
  def normalized_phones
    return if self.phones.blank?
    np=[]
    self.phones.split(/,|;/).each { |x| 
      p=parse_phone(x,lookup_city_in_address || get_current_city)
      np << p if p
    }
    np
  end
  
end
