class Result < ActiveRecord::Base
  belongs_to :link
  belongs_to :storage
  belongs_to :company

  before_save :strip_fields

  named_scope :checked, { :conditions => { :is_checked => true } }
  named_scope :not_checked, { :conditions => { :is_checked => false } }
  
  named_scope :updated, { :conditions => { :is_updated => true },
                          :limit => 10,
                          :order => :id,
                          :include => :link }

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

end
