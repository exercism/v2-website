require 'test_helper'

class CacheSolutionNumMentorsTest < ActiveSupport::TestCase
  test "caches correctly without abandoned solutions" do
    solution = create :solution
    create :solution_mentorship, solution: solution
    create :solution_mentorship, solution: solution
    create :solution_mentorship, solution: solution, abandoned: true

    CacheSolutionNumMentors.(solution)

    solution.reload
    assert_equal 2, solution.num_mentors
  end
end

