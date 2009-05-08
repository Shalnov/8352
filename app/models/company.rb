class Company < ActiveRecord::Base
  acts_as_taggable

  serialize :dump, Hash
  
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
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags,     :through => :taggings

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
end
