require 'application_system_test_case'

class ProfileSolutionsTest < ApplicationSystemTestCase
  test "orders solutions by number of stars" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:user_track, track: track, user: user)
    create(:profile, user: user)

    solution1 = create(:solution,
                       user: user,
                       num_stars: 1,
                       exercise: create(:exercise, title: "Exercise 3", track: track),
                       published_at: Date.new(2016, 12, 25),
                       show_on_profile: true)
    create_list(:solution_star, 1, solution: solution1)
    solution2 = create(:solution,
                       user: user,
                       num_stars: 2,
                       exercise: create(:exercise, title: "Exercise 2", track: track),
                       published_at: Date.new(2016, 12, 25),
                       show_on_profile: true)
    create_list(:solution_star, 2, solution: solution2)
    solution3 = create(:solution,
                        user: user,
                        num_stars: 3,
                        exercise: create(:exercise, title: "Exercise 1", track: track),
                        published_at: Date.new(2016, 12, 25),
                        show_on_profile: true)
    create_list(:solution_star, 3, solution: solution3)

    sign_in!(user)
    visit profile_path(user.handle)

    exercises = page.find_all(".solution .title").map(&:text)
    assert_equal ["Exercise 1", "Exercise 2", "Exercise 3"], exercises
  end

  test "updates solutions count correctly" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    ruby = create(:track, title: "Ruby")
    python = create(:track, title: "Python")
    create(:user_track, track: ruby, user: user)
    create(:user_track, track: python, user: user)
    create(:profile, user: user)

    create(:solution, user: user, exercise: create(:exercise, track: ruby), published_at: Date.new(2016, 12, 25), show_on_profile: true)
    create(:solution, user: user, exercise: create(:exercise, track: ruby), published_at: Date.new(2016, 12, 25), show_on_profile: true)
    create(:solution, user: user, exercise: create(:exercise, track: python), published_at: Date.new(2016, 12, 25), show_on_profile: true)

    sign_in!(user)
    visit profile_path(user.handle)
    assert_selector ".num-solutions", text: "Showing 3 solutions"

    select_option("Ruby", selector: "[name=track_id]")
    assert_selector ".num-solutions", text: "Showing 2 solutions"
  end
end
