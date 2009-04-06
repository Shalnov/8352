class Category < ActiveRecord::Base
  acts_as_category
  
  has_many :companies

  def self.all_for_select(except=nil)
    conditions = except.nil? ? [] : ['id <> ?', except]
    categories = self.find(:all, :conditions => conditions).collect { |cat| ["#{'-'*cat.ancestors_count} #{cat.name}", cat.id] }
    categories << ["-", nil]
  end
  
end
