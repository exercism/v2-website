require 'test_helper'

class FiltersSolutionsByStatusTest < ActiveSupport::TestCase
  test "filters solutions correctly" do

    never = create :solution
    awaiting_user = create :solution, last_updated_by_user_at: DateTime.now - 1.minute

    awaiting_user_and_stale = create :solution, last_updated_by_user_at: DateTime.now - 8.days

    requires_action = create :solution, last_updated_by_user_at: DateTime.now - 1.minute
    requires_action_and_stale = create :solution, last_updated_by_user_at: DateTime.now - 8.days

    completed = create :solution, completed_at: DateTime.now - 1.minute, last_updated_by_user_at: DateTime.now - 1.minute
    completed_and_stale = create :solution, completed_at: DateTime.now - 8.days, last_updated_by_user_at: DateTime.now - 8.days

    abandoned_and_awaiting_user = create :solution, last_updated_by_user_at: DateTime.now - 1.minute
    abandoned_and_requires_action = create :solution, last_updated_by_user_at: DateTime.now - 1.minute
    abandoned_and_completed = create :solution, completed_at: DateTime.now - 1.minute, last_updated_by_user_at: DateTime.now - 1.minute
    abandoned_and_stale = create :solution, last_updated_by_user_at: DateTime.now - 8.days

    user = create :user
    [awaiting_user, completed, completed_and_stale, awaiting_user_and_stale].each do |solution|
      create :solution_mentorship, solution: solution, user: user, requires_action: false
    end

    [requires_action, requires_action_and_stale].each do |solution|
      create :solution_mentorship, solution: solution, user: user, requires_action: true
    end

    [abandoned_and_awaiting_user, abandoned_and_completed, abandoned_and_stale].each do |solution|
      create :solution_mentorship, solution: solution, user: user, abandoned: true
    end

    [abandoned_and_requires_action].each do |solution|
      create :solution_mentorship, solution: solution, user: user, abandoned: true, requires_action: true
    end

    assert_equal [requires_action, requires_action_and_stale], FiltersSolutionsByStatus.filter(user.mentored_solutions, :requires_action)
    assert_equal [awaiting_user], FiltersSolutionsByStatus.filter(user.mentored_solutions, :awaiting_user)
    assert_equal [completed, completed_and_stale], FiltersSolutionsByStatus.filter(user.mentored_solutions, :completed)
    assert_equal [awaiting_user_and_stale], FiltersSolutionsByStatus.filter(user.mentored_solutions, :stale)
    assert_equal [abandoned_and_awaiting_user, abandoned_and_requires_action, abandoned_and_completed, abandoned_and_stale].sort, FiltersSolutionsByStatus.filter(user.mentored_solutions, :abandoned).sort
  end
end


