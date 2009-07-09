class ResultCategory < ActiveRecord::Base
  belongs_to :result
  belongs_to :category
end
