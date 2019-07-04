require 'test_helper'

class MentoredSolutionsQueryTest < ActiveSupport::TestCase
  test "excludes solutions where mentoring is not requested" do
    solution = create(:solution,
                      mentoring_requested_at: nil,
                      track_in_independent_mode: false,
                      num_mentors: 1)
    iteration = create(:iteration, solution: solution)
    create(:discussion_post, user: create(:user), iteration: iteration)

    assert_empty MentoredSolutionsQuery.()
  end

  test "excludes solutions where track is in independent mode" do
    solution = create(:solution,
                      mentoring_requested_at: Time.utc(2016, 12, 25),
                      track_in_independent_mode: true,
                      num_mentors: 1)
    iteration = create(:iteration, solution: solution)
    create(:discussion_post, user: create(:user), iteration: iteration)

    assert_empty MentoredSolutionsQuery.()
  end

  test "excludes solutions where number of mentors less than 1" do
    solution = create(:solution,
                      mentoring_requested_at: Time.utc(2016, 12, 25),
                      track_in_independent_mode: false,
                      num_mentors: 0)
    iteration = create(:iteration, solution: solution)
    create(:discussion_post, user: create(:user), iteration: iteration)

    assert_empty MentoredSolutionsQuery.()
  end

  test "excludes solutions with discussions by the system user only" do
    solution = create(:solution,
                      mentoring_requested_at: Time.utc(2016, 12, 25),
                      track_in_independent_mode: false,
                      num_mentors: 1)
    system = create(:user, :system)
    iteration = create(:iteration, solution: solution)
    create(:discussion_post,
           user: system,
           iteration: iteration,
           created_at: Date.new(2016, 12, 25))

    assert_empty MentoredSolutionsQuery.()
  end

  test "marks first_mentored_at as the time a human adds a discussion post" do
    solution = create(:solution,
                      mentoring_requested_at: Time.utc(2016, 12, 25),
                      track_in_independent_mode: false,
                      num_mentors: 1)
    system = create(:user, :system)
    human = create(:user, id: 2)
    iteration = create(:iteration, solution: solution)
    create(:discussion_post,
           user: system,
           iteration: iteration,
           created_at: Date.new(2016, 12, 25))
    create(:discussion_post,
           user: human,
           iteration: iteration,
           created_at: Date.new(2016, 12, 26))
    create(:discussion_post,
           user: human,
           iteration: iteration,
           created_at: Date.new(2016, 12, 27))

    solution = MentoredSolutionsQuery.().first

    assert_equal Date.new(2016, 12, 26), solution.first_mentored_at
  end

  test "computes wait time" do
    solution = create(:solution,
                      mentoring_requested_at: Time.utc(2016, 12, 25),
                      track_in_independent_mode: false,
                      num_mentors: 1)
    human = create(:user, id: 2)
    iteration = create(:iteration, solution: solution)
    create(:discussion_post,
           user: human,
           iteration: iteration,
           created_at: Date.new(2016, 12, 26))

    solution = MentoredSolutionsQuery.().first

    assert_equal 1.day, solution.wait_time
  end
end
