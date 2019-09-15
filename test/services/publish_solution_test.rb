require 'test_helper'

class PublishSolutionTest < ActiveSupport::TestCase
  test "publishes a solution correctly" do
    Timecop.freeze do
      solution = create :solution
      assert PublishSolution.(solution)
      solution.reload

      assert_equal Time.current.to_i, solution.published_at.to_i
      assert solution.show_on_profile
      assert solution.allow_comments
    end
  end
end
