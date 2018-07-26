require 'application_system_test_case'

class ProfileSolutionsTest < ApplicationSystemTestCase
  test "orders solutions by number of reactions" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:user_track, track: track, user: user)
    create(:profile, user: user)

    solution1 = create(:solution,
                       user: user,
                       num_reactions: 1,
                       exercise: create(:exercise, title: "Exercise 3", track: track),
                       published_at: Date.new(2016, 12, 25))
    create_list(:reaction, 1, solution: solution1)
    solution2 = create(:solution,
                       user: user,
                       num_reactions: 2,
                       exercise: create(:exercise, title: "Exercise 2", track: track),
                       published_at: Date.new(2016, 12, 25))
    create_list(:reaction, 2, solution: solution2)
    solution3 = create(:solution,
                        user: user,
                        num_reactions: 3,
                        exercise: create(:exercise, title: "Exercise 1", track: track),
                        published_at: Date.new(2016, 12, 25))
    create_list(:reaction, 3, solution: solution3)

    sign_in!(user)
    visit profile_path(user.handle)

    exercises = page.find_all(".solution .title").map(&:text)
    assert_equal ["Exercise 1", "Exercise 2", "Exercise 3"], exercises
  end
end
