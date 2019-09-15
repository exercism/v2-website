require 'test_helper'

module AnalysisServices
  class UnlockSolutionTest < ActiveSupport::TestCase

    test "removes any locks" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      system_lock = create :solution_lock, solution: solution, user: create(:user, :system)
      mentor_lock = create :solution_lock, solution: solution
      UnlockSolution.(solution)

      assert_raises ActiveRecord::RecordNotFound do
        system_lock.reload
      end

      assert mentor_lock.reload
    end
  end
end
