require 'test_helper'

class CategoryTest < Test::Unit::TestCase
  should_belong_to :parent

  should_have_many :companies
  
  should_validate_presence_of :name
  should_validate_presence_of :description
end