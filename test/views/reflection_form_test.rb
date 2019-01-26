require "test_helper"

class ReflectionFormTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    view.stubs(current_user: create(:user))
  end

  test "hides mentor rating for an auto approved solution" do
    exercise = build(:exercise, auto_approve: true)
    solution = build(:solution, exercise: exercise)

    render "my/solutions/reflection/form",
      solution: solution,
      mentor_iterations: 0

    refute_includes rendered, "Rate your mentors"
  end

  test "shows mentor rating for a solution" do
    exercise = build(:exercise, auto_approve: false)
    solution = build(:solution, exercise: exercise)

    render "my/solutions/reflection/form",
      solution: solution,
      mentor_iterations: 0

    assert_includes rendered, "Rate your mentors"
  end
end
