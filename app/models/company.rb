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

  RESULTS_FIELDS = { :name => :name,
                     :site => :site_url,
                     :working_time => :work_time,
                     :address => :address }
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
    RESULTS_FIELDS.each_pair {|k,v| update_attribute_w_check(k, res[v]) if res[v] != self[k] }
    if res.phones && !res.phones.blank?
      update_attribute_w_check(:phone, Phone.strip_non_digit(res.phones))
    end
    if res.email && !res.email.blank?
      update_attribute_w_check(:email, res.email)
    end
    #TODO: phones, emails
  end
  
  # update specified attribute
  # if attribute changed by moderator:
  #   1. mark record as need_human
  #   2. save attribute value in moderate_attributes hash
  def update_attribute_w_check(field, value)
    if moderate_attributes && moderate_attributes[field] && moderate_attributes[field][:status] == :operator_changed
      add_value_for_moderation(field, value)
      need_human = true
    else
      case field
      when :phone
        if self.phones.select {|p| p.number == value }.size == 0
          self.phones << Phone.new(:number => value)
        end
      when :email
        if self.emails.select {|e| e.email == value }.size == 0
          self.emails << Email.new(:email => value)
        end
      else
        self[field] = value
      end
    end
  end
  
  # save attribute values in moderate_attributes hash
  def store_attributes_from_result(res)
    RESULTS_FIELDS.each_pair {|k,v| add_value_for_moderation(k, res[v]) if res[v] != self[k] }
    # check phones and emails
    if res.phones && !res.phones.blank?
      phone = Phone.strip_non_digit(res.phones)
      if self.phones.select {|p| p.number == phone }.size == 0
        add_value_for_moderation(:phone, phone)
      end
    end
    if res.email && !res.email.blank?
      if self.emails.select {|e| e.email == res.email }.size == 0
        add_value_for_moderation(:email, res.email)
      end
    end
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
