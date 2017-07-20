require 'test_helper'

class SolutionsControllerTest < ActionDispatch::IntegrationTest

  {
    unlocked: "my-solution-unlocked-page",
    iterating: "my-solution-started-page",
    completed_unapproved: "my-solution-started-page",
    completed_approved: "my-solution-started-page",
  }.each do |status, page|
    test "shows with status #{status}" do
      sign_in!
      solution = send("create_#{status}_solution")
      create :user_track, user: @current_user, track: solution.exercise.track

      get my_solution_url(solution)
      assert_response :success
      assert_correct_page page
    end
  end

  test "reflects properly" do
    sign_in!
    solution = create :solution, user: @current_user
    iteration = create :iteration, solution: solution
    discussion_post_1 = create :discussion_post, iteration: iteration
    discussion_post_2 = create :discussion_post, iteration: iteration
    discussion_post_3 = create :discussion_post, iteration: iteration
    notes = "foobar"

    create :solution_mentorship, solution: solution, user: discussion_post_1.user
    create :solution_mentorship, solution: solution, user: discussion_post_3.user

    patch reflect_my_solution_url(solution), params: {
      notes: notes,
      mentor_reviews: {
        discussion_post_1.user_id => { rating: 3, review: "asdasd" },
        discussion_post_3.user_id => { rating: 2, review: "asdaqweqwewqewq" }
      }
    }

    assert_response :success

    solution.reload
    assert_equal solution.notes, notes
    assert_equal 2, SolutionMentorship.where.not(rating: nil).count
  end

  def create_unlocked_solution
    create :solution, user: @current_user
  end

  def create_iterating_solution
    solution = create :solution, user: @current_user
    iteration = create :iteration, solution: solution
    solution
  end

  def create_completed_unapproved_solution
    solution = create :solution, user: @current_user, completed_at: Date.yesterday
    iteration = create :iteration, solution: solution
    solution
  end

  def create_completed_approved_solution
    solution = create :solution, user: @current_user, completed_at: Date.yesterday, approved_by: create(:user)
    iteration = create :iteration, solution: solution
    solution
  end
end
