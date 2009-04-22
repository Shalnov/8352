class Phone < ActiveRecord::Base

  belongs_to :company

  validates_presence_of :number
  validates_numericality_of :number, :greater_than => 70000000000, :less_than => 80000000000
  
  def to_s
    number
  end
end
