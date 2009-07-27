class ResultCategory < ActiveRecord::Base
  
  self.establish_connection :grabber
  
  acts_as_taggable
  
  belongs_to :category
  belongs_to :source
  has_many :results, :dependent=>:nullify
  
  validates_uniqueness_of :category_name, :case_sensitive=>false, :scope => [:source_id]
  validates_presence_of :category_name

  after_save :update_results
  before_destroy :update_results
  
  def update_results
    Result.
      update_all({
                   :result_category_id=>self.id,
                   :state=>'updated'
                 },
                 {
                   :category_name=>self.category_name
                 })
  end
  
end
