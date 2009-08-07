# -*- coding: utf-8 -*-
#require 'acts_as_taggable'

class Company < ActiveRecord::Base
  
  acts_as_taggable
  
 # set_cached_tag_list_column_name "my_caching_column_name"

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
  has_many :emails,   :dependent => :destroy
  has_many :results
  has_many :sources,  :through=> :results
  
  
#  has_many :taggings, :as => :taggable, :dependent => :destroy
#  has_many :tags,     :through => :taggings



  validates_presence_of :name, :category_id #, :full_name
  
  accepts_nested_attributes_for :phones, :allow_destroy => true,
                                :reject_if => proc { |phone| phone['number'].blank? }
  accepts_nested_attributes_for :emails, :allow_destroy => true
  

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
    
    if phone=Phone.find_by_number(h[:number])
      # TODO Поискать чего обновлять в телефонах
      # TODO Устанавливать необходимость ручной замены, если изменился is_fax или department

      phone.update_attribute(:department,h[:department]) if phone.department.blank? && !h[:department].blank?
      phone.save!
    else

      self.phones.create(h) || raise(RecordNotSaved)
    end
    
  end
  
  
  def update_phones(phones)
    # TODO сохранять порядок телефонов (position)
    phones.andand.each{ |x| self.update_phone(x)  }
  end
  
  
  def update_description
    # TODO Проверять не закрыт ли
    self.description=results.andand.map(&:other_info).join("\n------------------------\n")
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
