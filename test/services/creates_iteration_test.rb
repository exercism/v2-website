require 'test_helper'

class CreatesIterationTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    solution = create :solution
    code = "foobar"

    iteration = CreatesIteration.create!(solution, code)

    assert iteration.persisted?
    assert_equal iteration.solution, solution
    assert_equal iteration.code, code
  end
end

