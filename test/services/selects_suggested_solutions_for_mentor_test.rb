require 'test_helper'

class SelectsSuggestedSolutionsForMentorTest < ActiveSupport::TestCase
  test "selects only mentored tracks" do
    user = create :user
    track1 = create :track
    track2 = create :track
    track3 = create :track

    solution1 = create :solution, exercise: create(:exercise, track: track1)
    solution2 = create :solution, exercise: create(:exercise, track: track2)
    solution3 = create :solution, exercise: create(:exercise, track: track3)
    create :iteration, solution: solution1
    create :iteration, solution: solution2
    create :iteration, solution: solution3

    create :track_mentorship, user: user, track: track1
    create :track_mentorship, user: user, track: track2

    assert_equal [solution1, solution2].sort, SelectsSuggestedSolutionsForMentor.select(user).sort
  end

  test "does not select solutions you already mentor" do
    user, track = create_user_and_track

    bad_solution = create :solution, exercise: create(:exercise, track: track)
    good_solution = create :solution, exercise: create(:exercise, track: track)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution
    create :solution_mentorship, user: user, solution: bad_solution

    assert_equal [good_solution].sort, SelectsSuggestedSolutionsForMentor.select(user).sort
  end

  test "only selects solutions that have an iteration" do
    user, track = create_user_and_track

    bad_solution = create :solution, exercise: create(:exercise, track: track)
    good_solution = create :solution, exercise: create(:exercise, track: track)
    create :iteration, solution: good_solution

    assert_equal [good_solution].sort, SelectsSuggestedSolutionsForMentor.select(user).sort
  end

  test "does not select solutions with >=3 mentors" do
    user, track = create_user_and_track

    bad_solution = create :solution, exercise: create(:exercise, track: track), num_mentors: 3
    good_solution = create :solution, exercise: create(:exercise, track: track), num_mentors: 2
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution].sort, SelectsSuggestedSolutionsForMentor.select(user).sort
  end

  test "does not select approved solutions" do
    user, track = create_user_and_track

    bad_solution = create :solution, exercise: create(:exercise, track: track), approved_by: create(:user)
    good_solution = create :solution, exercise: create(:exercise, track: track), approved_by: nil
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution].sort, SelectsSuggestedSolutionsForMentor.select(user).sort
  end

  test "does not select completed solutions" do
    user, track = create_user_and_track

    bad_solution = create :solution, exercise: create(:exercise, track: track), completed_at: DateTime.now - 1.minute
    good_solution = create :solution, exercise: create(:exercise, track: track), completed_at: nil
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution].sort, SelectsSuggestedSolutionsForMentor.select(user).sort
  end

  test "orders by number of mentors then time" do
    user, track = create_user_and_track

    m2_solution_old = create :solution, exercise: create(:exercise, track: track), num_mentors: 2, last_updated_by_user_at: DateTime.now - 2.week
    m2_solution_new = create :solution, exercise: create(:exercise, track: track), num_mentors: 2, last_updated_by_user_at: DateTime.now - 1.week
    m0_solution_new = create :solution, exercise: create(:exercise, track: track), num_mentors: 0, last_updated_by_user_at: DateTime.now - 1.week
    m0_solution_old = create :solution, exercise: create(:exercise, track: track), num_mentors: 0, last_updated_by_user_at: DateTime.now - 2.week
    m1_solution_old = create :solution, exercise: create(:exercise, track: track), num_mentors: 1, last_updated_by_user_at: DateTime.now - 2.week
    m1_solution_new = create :solution, exercise: create(:exercise, track: track), num_mentors: 1, last_updated_by_user_at: DateTime.now - 1.week

    [m0_solution_old, m0_solution_new, m1_solution_old, m1_solution_new, m2_solution_old, m2_solution_new].each do |solution|
      create :iteration, solution: solution
    end

    expected = [m0_solution_old, m0_solution_new, m1_solution_old, m1_solution_new, m2_solution_old, m2_solution_new]
    actual = SelectsSuggestedSolutionsForMentor.select(user)

    assert_equal actual.map(&:id), expected.map(&:id)
  end

  def create_user_and_track
    user = create :user
    track = create :track
    create :track_mentorship, user: user, track: track
    [user, track]
  end
end
