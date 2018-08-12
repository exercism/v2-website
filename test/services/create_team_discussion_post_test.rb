require 'test_helper'

class CreateTeamDiscussionPostTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    Timecop.freeze do
      solution = create :team_solution
      iteration = create :iteration, solution: solution
      user = solution.user
      content = "foobar"

      post = CreateTeamDiscussionPost.(iteration, user, content)

      assert post.persisted?
      assert_equal post.iteration, iteration
      assert_equal post.user, user
      assert_equal post.content, content
    end
  end

  test "succeeds if team member" do
    solution = create :team_solution
    iteration = create :iteration, solution: solution
    user = create :user
    create :team_membership, user: user, team: solution.team
    assert CreateTeamDiscussionPost.(iteration, user, "foobar")
  end

  test "fails if not a team member" do
    solution = create :team_solution
    iteration = create :iteration, solution: solution
    refute CreateTeamDiscussionPost.(iteration, create(:user), "foobar")
  end

  test "updates solution for solution user posting" do
    solution = create :team_solution, needs_feedback: false, has_unseen_feedback: true
    iteration = create :iteration, solution: solution
    CreateTeamDiscussionPost.(iteration, solution.user, "foobar")

    solution.reload
    assert solution.needs_feedback
    refute solution.has_unseen_feedback
  end

  test "updates solution for a different user posting" do
    solution = create :team_solution, needs_feedback: true, has_unseen_feedback: false
    iteration = create :iteration, solution: solution
    user = create :user
    create :team_membership, user: user, team: solution.team
    CreateTeamDiscussionPost.(iteration, user, "foobar")

    solution.reload
    refute solution.needs_feedback
    assert solution.has_unseen_feedback
  end
end
