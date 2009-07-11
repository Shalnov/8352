class ResultCategory < ActiveRecord::Base
  belongs_to :result
  belongs_to :category
  
  def self.uniq_unprocessed_categories
    self.find(:all, :select => "distinct(category_name)", :conditions => "category_id IS NULL").map{|r| r.category_name}.compact.sort
  end
end
