class ResultCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :source
  has_many :results, :dependent=>:nullify
  
  after_save :update_results
  before_destroy :update_results
  
  def update_results
    Result.
      update_all({
                   :result_category_id=>self.id,
                   :is_updated=>true
                 },
                 {
                   :category_name=>self.category_name
                 })
  end
  
end
