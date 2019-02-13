require "application_system_test_case"

class SolutionTest < ApplicationSystemTestCase
  setup do
    @mentor = create(:user_mentor)
    @track = create(:track, title: "Ruby")
    create :track_mentorship, user: @mentor, track: @track

    exercise = create :exercise, track: @track, title: "Two Fer"
    @solution = create :solution, exercise: exercise, mentoring_requested_at: Time.current
    @iteration = create :iteration, solution: @solution

    sign_in!(@mentor)
  end

  test "title is redacted" do
    visit mentor_solution_path(@solution)
    assert_equal "#{@solution.user.handle} | Ruby/Two Fer | Exercism", page.title

    @solution.update(num_mentors: 1)
    visit mentor_solution_path(@solution)
    assert_equal "[Redacted] | Ruby/Two Fer | Exercism", page.title

    create :solution_mentorship, user: @mentor, solution: @solution
    visit mentor_solution_path(@solution)
    assert_equal "#{@solution.user.handle} | Ruby/Two Fer | Exercism", page.title
  end
end
