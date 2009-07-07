#require 'acts_as_taggable'

#TODO: when operator changes racord - update moderate_attributes

class Company < ActiveRecord::Base
#  acts_as_taggable

  serialize :dump, Hash
  serialize :moderate_attributes, Hash
  
  define_index do
    indexes :name, :sortable => true
    indexes full_name, :sortable => true
    indexes description
    indexes address
    indexes category.name, :as => :category
    indexes [
      phones.number, phones.person
    ], :as => :phone
    indexes emails.email, :as => :emails

    # необходимо для поиска '*ксары*' => Чебоксары
    set_property :enable_star => 1
    set_property :min_infix_len => 1
  end
  
  belongs_to :category, :counter_cache => true

  has_many :phones,   :dependent => :destroy
  has_many :emails,   :dependent => :destroy
#  has_many :taggings, :as => :taggable, :dependent => :destroy
#  has_many :tags,     :through => :taggings

  has_many :results

  validates_presence_of :name, :full_name
  
  accepts_nested_attributes_for :phones, :allow_destroy => true,
                                :reject_if => proc { |phone| phone['number'].blank? }
  accepts_nested_attributes_for :emails, :allow_destroy => true

  class << self
    def find_with_scope( *args )
      options = args.extract_options!
      if options.has_key?(:conditions)
        if options[:conditions].is_a?(String)
          pending_state = options[:conditions].include?('pending')
        elsif options[:conditions].is_a?(Hash)
          pending_state = options[:conditions].delete(:pending)
        end
      else
        pending_state = options.delete( :pending )
      end
      unless pending_state
        with_scope( :find => { :conditions => [ 'pending = false' ] } ) do
          find_without_scope( *args << options )
        end
      else
        find_without_scope( *args << options )
      end
    end
  
    alias_method_chain :find, :scope
  end
  
  def dump_attributes
    self.dump ||= {}
    self.dump[Time.now.strftime('%Y%m%d%H%M%S')] = 
                { :company => Marshal.dump(self),
                  :phones => Marshal.dump(self.phones),
                  :emails => Marshal.dump(self.emails),
                  :tags => Marshal.dump(self.tags) }
    self.write_attribute(:dump, self.dump)
  end
  
  # update attributes
  def update_attributes_from_result(res)
    update_attribute_w_check(:name, res.name)               if res.name != name
    update_attribute_w_check(:site, res.site_url)           if res.site_url != site
    update_attribute_w_check(:working_time, res.work_time)  if res.work_time != working_time
    update_attribute_w_check(:address, res.address)         if res.address != address
    #TODO: phones, emails
  end
  
  # update specified attribute
  # if attribute changed by moderator:
  #   1. mark record as need_human
  #   2. save attribute value in moderate_attributes hash
  def update_attribute_w_check(field, value)
    if moderate_attributes[field] && moderate_attributes[field][:status] == :operator_changed
      add_value_for_moderation(field, value)
      need_human = true
    else
      self[field] = value
    end
  end
  
  # save attribute values in moderate_attributes hash
  def store_attributes_from_result(res)
    add_value_for_moderation(:name, res.name)               if res.name != name
    add_value_for_moderation(:site, res.site_url)           if res.site_url != site
    add_value_for_moderation(:working_time, res.work_time)  if res.work_time != working_time
    add_value_for_moderation(:address, res.address)         if res.address != address
    #TODO: phones, emails
  end
  
  # add value to hash by key - current time
  # if update to frequently - store only 5 values
  def add_value_for_moderation(field, value)
    moderate_attributes[field] ||= {}
    moderate_attributes[field][:versions] ||= {}
    versions = moderate_attributes[field][:versions]

    time_key = Time.now.strftime('%Y%m%d%H%M%S')
    
    if versions && versions[time_key]
      if versions[time_key] == value
        return
      else
        unless 5.times do |i|
                 unless versions[time_key + i.to_s]
                   time_key = time_key + i.to_s
                 end
               end
          time_key = time_key + "5"
        end
      end
    end
    versions[time_key] = value
  end
end
