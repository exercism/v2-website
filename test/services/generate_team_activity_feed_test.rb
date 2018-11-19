require 'test_helper'

class GenerateTeamActivityFeedTest < ActiveSupport::TestCase
  test "generates correctly" do
    team = create :team

    d4_solution = create :team_solution, team: team, created_at: 4.days.ago
    d7_solution = create :team_solution, team: team, created_at: 7.days.ago
    d8_iteration = create :iteration, solution: d4_solution, created_at: 8.days.ago
    d2_iteration = create :iteration, solution: d4_solution, created_at: 2.days.ago
    d5_membership = create :team_membership, team: team, created_at: 5.day.ago
    d6_membership = create :team_membership, team: team, created_at: 6.days.ago
    d3_feedback = create :discussion_post, iteration: d8_iteration, created_at: 3.days.ago
    d9_feedback = create :discussion_post, iteration: d8_iteration, created_at: 9.days.ago

    expected = [d2_iteration,d3_feedback,d4_solution,d5_membership,d6_membership,d7_solution,d8_iteration,d9_feedback]
    activities = GenerateTeamActivityFeed.(team)
    assert_equal expected, activities
  end

  test "limits to 20" do
    team = create :team

    10.times { create :team_membership, team: team }
    10.times { create :team_solution, team: team }
    10.times { create :iteration, solution: create(:team_solution, team: team) }
    10.times { create :discussion_post, iteration: create(:iteration, solution: create(:team_solution, team: team)) }

    assert_equal 20, GenerateTeamActivityFeed.(team).size
  end
end

