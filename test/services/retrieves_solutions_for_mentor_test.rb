require "test_helper"

class RetrievesSolutionsForMentorTest < ActiveSupport::TestCase
  test "filters by status by default" do
    user = create(:user)
    solution = create(:solution)
    create(:solution_mentorship,
           user: user,
           solution: solution)
    FiltersSolutionsByStatus.expects(:filter).with([solution], nil)

    RetrievesSolutionsForMentor.retrieve(user)
  end

  test "filters mentored solutions by status" do
    user = create(:user)
    solution = create(:solution, completed_at: Date.new(2016, 12, 25))
    create(:solution_mentorship,
           user: user,
           solution: solution,
           requires_action: false,
           abandoned: false
          )

    completed_solutions = RetrievesSolutionsForMentor.retrieve(
      user,
      status: :completed
    )
    abandoned_solutions = RetrievesSolutionsForMentor.retrieve(
      user,
      status: :abandoned
    )

    assert_equal [solution], completed_solutions
    assert_equal [], abandoned_solutions
  end

  test "filters mentored solutions by track" do
    ruby = create(:track, title: "Ruby")
    cpp = create(:track, title: "C++")
    user = create(:user, mentored_tracks: [ruby, cpp])
    hello_world_ruby = create(:exercise, track: ruby)
    solution_ruby = create(:solution, exercise: hello_world_ruby)
    hello_world_cpp = create(:exercise, track: cpp)
    solution_cpp = create(:solution, exercise: hello_world_cpp)
    create(:solution_mentorship,
           user: user,
           solution: solution_ruby,
           requires_action: true)
    create(:solution_mentorship,
           user: user,
           solution: solution_cpp,
           requires_action: true)

    cpp_solutions = RetrievesSolutionsForMentor.retrieve(
      user,
      track_id: cpp.id
    )
    ruby_solutions = RetrievesSolutionsForMentor.retrieve(
      user,
      track_id: ruby.id
    )

    assert_equal [solution_cpp], cpp_solutions
    assert_equal [solution_ruby], ruby_solutions
  end

  test "filters mentored solutions by exercise" do
    ruby = create(:track, title: "Ruby")
    user = create(:user, mentored_tracks: [ruby])
    hello_world = create(:exercise, title: "Hello World", track: ruby)
    sorting = create(:exercise, title: "Sorting", track: ruby)
    hello_world_solution = create(:solution, exercise: hello_world)
    create(:solution_mentorship,
           user: user,
           solution: hello_world_solution,
           requires_action: true)
    sorting_solution = create(:solution, exercise: sorting)
    create(:solution_mentorship,
           user: user,
           solution: sorting_solution,
           requires_action: true)

    hello_world_solutions = RetrievesSolutionsForMentor.retrieve(
      user,
      track_id: ruby.id,
      exercise_id: hello_world.id
    )
    sorting_solutions = RetrievesSolutionsForMentor.retrieve(
      user,
      track_id: ruby.id,
      exercise_id: sorting.id
    )

    assert_equal [hello_world_solution], hello_world_solutions
    assert_equal [sorting_solution], sorting_solutions
  end
end
