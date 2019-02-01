require 'test_helper'

class CreateSolutionStarTest < ActiveSupport::TestCase
  test "creates solution_star" do
    user = create :user
    solution = create :solution

    CreateNotification.expects(:call).with do |*args|
      assert_equal solution.user, args[0]
      assert_equal :new_solution_star, args[1]
      assert_equal "<strong>#{user.handle}</strong> has starred your solution to <strong>#{solution.exercise.title}</strong> on the <strong>#{solution.exercise.track.title}</strong> track.", args[2]
      assert_equal "https://test.exercism.io/solutions/#{solution.uuid}", args[3]
      assert_equal SolutionStar, args[4][:trigger].class
      assert_equal solution, args[4][:about]
    end

    solution_star = CreateSolutionStar.(user, solution)
    solution.reload

    assert_equal 1, solution.stars.count
    assert solution_star.persisted?
    assert_equal solution, solution_star.solution
    assert_equal user, solution_star.user
    assert_equal 1, solution.num_stars
  end

  test "destroys solution_star" do
    user = create :user
    solution = create :solution
    original_solution_star = create :solution_star, user: user, solution: solution
    CreateSolutionStar.(user, solution)
    solution.reload

    assert_equal 0, solution.stars.count
    assert_equal 0, solution.num_stars
  end

  test "destroys solution_star and notifications" do
    user = create :user
    solution = create :solution
    solution_star = create :solution_star, user: user, solution: solution
    other_notification = create :notification, user: solution.user
    notification = create :notification, user: solution.user, type: :new_solution_star, trigger: solution_star

    CreateSolutionStar.(user, solution)

    solution.user.reload
    assert_equal [other_notification], solution.user.notifications
  end
end
