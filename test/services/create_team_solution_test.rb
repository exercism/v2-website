require 'test_helper'

class CreatesTeamSolutionTest < ActiveSupport::TestCase
  test "creates with correct git sha" do
    user = create :user
    team = create :team
    create :team_membership, user: user, team: team
    exercise = create :exercise
    git_sha = SecureRandom.uuid
    Git::ExercismRepo.stubs(current_head: git_sha)
    solution = CreateTeamSolution.(user, team, exercise)

    assert solution.persisted?
    assert_equal exercise, solution.exercise
    assert_equal user, solution.user
    assert_equal team, solution.team
    assert_equal exercise.slug, solution.git_slug
    assert_equal solution.git_sha, git_sha
  end

  test "doesn't duplicate solutions" do
    user = create :user
    team = create :team
    create :team_membership, user: user, team: team
    exercise = create :exercise
    git_sha = SecureRandom.uuid
    Git::ExercismRepo.stubs(current_head: git_sha)

    solution1 = CreateTeamSolution.(user, team, exercise)
    solution2 = CreateTeamSolution.(user, team, exercise)
    assert_equal solution1.id, solution2.id
  end

  test "doesn't create for non members" do
    user = create :user
    team = create :team
    assert_raises(TeamMembership::InvalidMembership) do
      CreateTeamSolution.(user, team, create(:exercise))
    end
  end

end
