require "application_system_test_case"

class SolutionsTest < ApplicationSystemTestCase
  test "shows test suite" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    create(:user_track, track: track, user: user)
    exercise = create(:exercise, track: track, slug: "hello-world")
    solution = create(:solution,
                      exercise: exercise,
                      user: user,
                      git_sha: Git::ExercismRepo.current_head(track.repo_url),
                      git_slug: "hello-world")
    iteration = create(:iteration, solution: solution)

    stub_repo_cache! do
      sign_in!(user)
      visit my_solution_path(solution)
    end

    find(:css, ".tab", text: "Test suite").click
    assert_text "This is the test suite"
  end

  test "index test suite" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    solution = create(:solution, published_at: Time.now)

    sign_in!(user)
    visit track_exercise_solutions_path(solution.track, solution.exercise)
  end

  test "can react to a solution" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    solution = create(:solution, published_at: Time.now)

    sign_in!(user)
    visit solution_path(solution)

    assert_equal 0, solution.reactions.count

    assert_selector ".react", text: "React to this solution"
    find(".react .like").click
    assert_selector ".react .like.selected"

    solution.reload
    assert_equal 1, solution.reactions.count
  end

  test "can unreact to a solution" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    solution = create(:solution, published_at: Time.now)
    reaction = create(:reaction, user: user, solution: solution, emotion: :like, comment: nil)

    sign_in!(user)
    visit solution_path(solution)

    assert_equal 1, solution.reactions.count

    assert_selector ".react", text: "React to this solution"
    find(".react .like.selected").click
    assert_no_selector ".react .like.selected", wait: 10

    solution.reload
    assert_equal 0, solution.reactions.count
  end

  test "can unreact to a solution with a comment" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    solution = create(:solution, published_at: Time.now)
    reaction = create(:reaction, user: user, solution: solution, emotion: :like)

    sign_in!(user)
    visit solution_path(solution)

    assert_equal 1, solution.reactions.count
    assert_equal "like", solution.reactions.first.emotion

    assert_selector ".react", text: "React to this solution"
    find(".react .like.selected").click
    assert_no_selector ".react .like.selected", wait: 10

    solution.reload
    assert_equal 1, solution.reactions.count
    assert_equal "legacy", solution.reactions.first.emotion
  end
end
