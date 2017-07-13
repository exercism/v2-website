require 'test_helper'

class CreatesIterationTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      assert_nil solution.last_updated_by_user_at

      code = "foobar"

      iteration = CreatesIteration.create!(solution, code)

      assert iteration.persisted?
      assert_equal iteration.solution, solution
      assert_equal iteration.code, code
      assert_equal DateTime.now.to_i, solution.last_updated_by_user_at.to_i
    end
  end
end

