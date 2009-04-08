require 'test_helper'

class CompanyTest < Test::Unit::TestCase
  should_belong_to :category

  should_have_many :phones
  should_have_many :emails
  should_have_many :tags, :through => :taggings

  should_validate_presence_of :name
  should_validate_presence_of :full_name
end