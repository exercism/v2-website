require 'application_system_test_case'

class My::SolutionTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    Git::ExercismRepo.stubs(pages: [])
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    sign_in!(@user)
  end

  test "command hint fields should be readonly" do
    exercise = create :exercise
    user_track = create :user_track, user: @user, track: exercise.track
    solution = create(:solution, user: @user, exercise: exercise)
    visit my_solution_path(solution)

    assert find_all("input.download-code").all? { |i| i["readonly"] }
  end
end
