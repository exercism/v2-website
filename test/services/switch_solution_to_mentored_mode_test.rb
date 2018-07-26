require 'test_helper'

class SwitchSolutionToMentoredModeTest < ActiveSupport::TestCase
  test "sets uncompleted solutions to independent mode" do
    solution = create :solution,
                      independent_mode: true,
                      completed_at: Time.now - 1.week,
                      published_at: Time.now - 1.week,
                      approved_by: create(:user),
                      last_updated_by_user_at: Time.now - 1.week,
                      updated_at: Time.now - 1.week


    SwitchSolutionToMentoredMode.(solution)

    solution.reload
    refute solution.independent_mode?
    assert_nil solution.completed_at
    assert_nil solution.published_at
    assert_nil solution.approved_by
    assert_equal Time.now.to_i, solution.last_updated_by_user_at.to_i
    assert_equal Time.now.to_i, solution.updated_at.to_i
  end
end


