class Result < ActiveRecord::Base
  belongs_to :link
  belongs_to :storage
  belongs_to :company

  has_one :result_category
  
  before_save :strip_fields

  named_scope :checked, { :conditions => { :is_checked => true } }
  named_scope :not_checked, { :conditions => { :is_checked => false } }
  
  named_scope :updated, { :conditions => { :is_updated => true },
                          :limit => 10,
                          :order => :id,
                          :include => :link }

  IMPORT_CONDITIONS = ["is_updated = :is_updated AND result_categories.category_id IS NOT NULL",
                                      { :is_updated => true }]

  def strip_fields
    self.strip_field!(:name)
    self.strip_field!(:address)
    self.strip_field!(:phones)
    self.strip_field!(:email)
    self.strip_field!(:site_url)
    self.strip_field!(:category)
    self.strip_field!(:work_time)
  end

  def strip_field!(field = nil)
    false
    if self.attribute_names.include?(field.to_s) && 
       !self[field].nil? && (self[field].mb_chars.length > self.column_for_attribute(field).limit)
      self.update_attribute field, self[field].mb_chars[0..(self.column_for_attribute(field).limit - 1)].to_s
    end
  end

  def phones_str
    self.phones.to_s.gsub(/\D/,'')
  end

  def phones_exist?
    !phones_str.size.zero?
  end

  def self.next_for_import
<<<<<<< HEAD:app/models/result.rb
    self.find(:first, :include => [:result_category], 
                      :conditions => IMPORT_CONDITIONS)
  end
  
  def self.records_for_import
    self.find(:all, :include => [:result_category], 
                      :conditions => IMPORT_CONDITIONS)
=======
    self.find(:first, :conditions => {:is_updated => true})
>>>>>>> bfba66347e3e2ae8efb0809d952ae5225bbb01f7:app/models/result.rb
  end
end
