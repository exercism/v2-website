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

  test "updates last updated by" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      assert_nil solution.last_updated_by_user_at

      CreatesIteration.create!(solution, "Foobar")
      assert_equal DateTime.now.to_i, solution.last_updated_by_user_at.to_i
    end
  end

  test "set all mentors' requires_action to true" do
    solution = create :solution
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: solution, requires_action: false

    CreatesIteration.create!(solution, "Foobar")

    mentorship.reload
    assert mentorship.requires_action
  end

end

