# -*- coding: utf-8 -*-
#require 'acts_as_taggable'

class Company < ActiveRecord::Base
#  acts_as_taggable

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

  has_many :phones,   :dependent => :destroy
  has_many :emails,   :dependent => :destroy
  
#  has_many :taggings, :as => :taggable, :dependent => :destroy
#  has_many :tags,     :through => :taggings

  has_many :results

  validates_presence_of :name, :category_id #, :full_name
  
  accepts_nested_attributes_for :phones, :allow_destroy => true,
                                :reject_if => proc { |phone| phone['number'].blank? }
  accepts_nested_attributes_for :emails, :allow_destroy => true
  

  class << self    
    
    def get_company_by_phones(phones)
      c = nil
      if phones
        phones.split(',').each do |phone|
          formated_phone = Phone.strip_non_digit(phone).to_i
          c = p.company if formated_phone && formated_phone != 0 && p = Phone.find_by_number(formated_phone)
          break
        end
      end
      c
    end
    
    
    # Давайте мне хэш телефонов и я найду компанию
    def find_by_phones(phones)
      
      # TODO определить тип hash/array/string/number и делать поступать соответсвенно
      return nil unless phones && phones.size>0
      phones.each_key { |number|
        phone=Phone.find_by_number(number)        
        return phone.company if phone
      }
      nil
    end
    
    def find_by_result(res)
      self.find_by_phones(res.normalized_phones) || self.find_by_name(res.name)
    end
      
  end
  
  
  def update_phones(phones)
    return unless phones
    phones.each_key { |number|
      if phone=Phone.find_by_number(number)
        # TODO Поискать чего обновлять в телефонах
      else
        Phone.create!(:company_id=>self.id,
                      :number=>number,
                      :department=>phones[number])
      end
    }
  end
  
#    RESULTS_FIELDS.each_pair {|k,v| update_attribute_w_check(k, res[v]) if res[v] != self[k] }
  
#   def dump_attributes
#     self.dump ||= {}
#     self.dump[Time.now.strftime('%Y%m%d%H%M%S')] = 
#                 { :company => Marshal.dump(self),
#                   :phones => Marshal.dump(self.phones),
#                   :emails => Marshal.dump(self.emails),
#                   :tags => Marshal.dump(self.tags) }
#     self.write_attribute(:dump, self.dump)
#   end
end
