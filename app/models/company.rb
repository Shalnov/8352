# -*- coding: utf-8 -*-
#require 'acts_as_taggable'

class Company < ActiveRecord::Base

  
  serialize  :ymaps
  
  serialize  :parsed_address # разобранный адрес от яндекса, см result.rb


#  serialize :dump, Hash
  
#   define_index do
#     indexes :name, :sortable => true
# #    indexes full_name, :sortable => true
#     indexes description
#     indexes address
#     indexes category.name, :as => :category
#     indexes [
#       phones.number, phones.person
#     ], :as => :phone
#     indexes emails.email, :as => :emails

#     # необходимо для поиска '*ксары*' => Чебоксары
#     set_property :enable_star => 1
#     set_property :min_infix_len => 1
#   end
  
  belongs_to :category, :counter_cache => true
  belongs_to :city, :counter_cache => true

  has_many :phones,   :dependent => :destroy
#  has_many :emails,   :dependent => :destroy
  has_many :results
  has_many :sources,  :through=> :results
  
  
  validates_presence_of :name, :category_id #, :full_name
  
  accepts_nested_attributes_for :phones, :allow_destroy => true,
                                :reject_if => proc { |phone| phone['number'].blank? }
#  accepts_nested_attributes_for :emails, :allow_destroy => true
  

  class << self    
    
    
    # Давайте мне хэш телефонов и я найду компанию
    def find_by_phones(phones)
      # TODO определить тип hash/array/string/number и делать поступать соответсвенно
      
      phones.andand.each { |h|
        unless h[:number].blank?
          phone=Phone.find_by_number(h[:number])
          return phone.company if phone
        end
      }
      nil
    end
    
    def find_by_result(res)
      self.find_by_phones(res.parsed_phones) || self.find_by_name(res.normalized_name)
      
      # NOTE Слишком опасно искать по короткому имени, могут находиться похожие компании
      #|| self.find_by_short_name(res.short_name)
    end
      
  end
  
  
  def update_phone(h)
    
    if phone=self.phones.find_by_number(h[:number])
      # TODO Поискать чего обновлять в телефонах
      # TODO Устанавливать необходимость ручной замены, если изменился is_fax или department

      phone.update_attribute(:department,h[:department]) if phone.department.blank? && !h[:department].blank?
      phone.save!
    else

      self.phones.create(h) || raise(RecordNotSaved)
    end
    
  end
  
  
  def update_emails(email)
    return unless email
    email.strip!
    if self.emails.blank?
      self.emails=email
    elsif self.emails!=email
      self.emails="#{self.emails}, #{email}"
    end
  end
  
  
  def update_phones(phones)
    # TODO сохранять порядок телефонов (position)
    phones.andand.each{ |x| self.update_phone(x)  }
  end
  
  def update_address
    # TODO Проверять не закрыт ли
    results.andand.map { |r|
      if r.parsed_address[:precision]=='exact'
        self.address=r.parsed_address[:addr]
        self.parsed_address=r.parsed_address
        self.ymaps=r.ymaps
      end
    }
  end
  
  def update_description
    # TODO Проверять не закрыт ли
    self.description=results.andand.map(&:other_info).join("\n------------------------\n")
  end

  
end
