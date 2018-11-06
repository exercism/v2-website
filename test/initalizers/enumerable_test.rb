require 'test_helper'

class EnumerableTest < ActiveSupport::TestCase
  test "avg" do
    assert_equal 2.75, [1,2,3,5].avg
  end
end
