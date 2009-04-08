require 'test_helper'

class RoleTest < Test::Unit::TestCase
  should_have_and_belong_to_many :users

  should_validate_presence_of :name
end