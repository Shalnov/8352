# -*- coding: utf-8 -*-
require "phone_parser"
require "address_parser"

class AdResult < ActiveRecord::Base
  
  self.establish_connection :grabber
  
  belongs_to :ad_result_category
  belongs_to :source
  #has_one :category, :through=>:result_category

#  include PhoneHelper
  #  extend ActiveSupport::Memoizable

  serialize :fields, Hash

  def fields
    value = super
    if value.is_a?(Hash)
      value
    else
      self.fields = Hash.new
    end
  end

  def fields_names
    self.fields.keys
  end

  def field_exist? field
    fields_names.include?(field.to_sym)
  end
  
  
  # ---

  class << self
    public :define_method
  end

  def method_missing *args
    method = args.shift
    value  = args.shift
    return super if method.nil?
    return super method unless method.to_s =~ /^field_/

    if method.to_s =~ /=/
      self.class.define_method(method) do
        self.fields.merge! method.to_s.gsub!('=','').to_sym => value
      end
    else
      self.class.define_method(method) do
        self.fields[method]
      end
    end

    self.send method, value
  end

# ------------------------------------------------------------------------------

  
    
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
  # , :initial => nil
  state_machine :importer_state do
    
    before_transition [:fine,:partly,:pending]=>any,  :do => :mark_imported
    
    event :mark_none do
      transition all => :none
    end

    event :mark_fine do
      transition :prepared => :fine
    end

    event :mark_partly do
      transition :prepared => :partly
    end

    event :mark_prepared do
      transition :none => :prepared
    end

    event :mark_pending do
      transition :prepared => :pending
    end

    event :mark_error do
      transition :prepared => :error
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
      :conditions => ["state='updated' and ad_results.source_id=? and ad_result_category_id is not null",
                      source_id]
    }
  }
  
  
  # для typus
  
  def self.importer_state
    ['none','prepared','fine','partly','pending','error']
  end

  def self.state
    ['updated','imported']
  end

  
end
