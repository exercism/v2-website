require 'test_helper'

class SelectSuggestedSolutionsForMentorTest < ActiveSupport::TestCase
  test "only selects solutions for tracks that you are mentoring" do
    mentor = create(:user)
    mentored_track1 = create :track
    mentored_track2 = create :track
    unmentored_track = create :track
    mentee = create_mentee([mentored_track1, mentored_track2, unmentored_track])

    solution1 = create(:solution,
                       exercise: create(:exercise, track: mentored_track1),
                       user: mentee,
                       mentoring_requested_at: Time.current)
    solution2 = create(:solution,
                       exercise: create(:exercise, track: mentored_track2),
                       user: mentee,
                       mentoring_requested_at: Time.current)
    solution3 = create(:solution,
                       exercise: create(:exercise, track: unmentored_track),
                       user: mentee,
                       mentoring_requested_at: Time.current)
    create :iteration, solution: solution1
    create :iteration, solution: solution2
    create :iteration, solution: solution3

    create :track_mentorship, user: mentor, track: mentored_track1
    create :track_mentorship, user: mentor, track: mentored_track2

    assert_equal [solution1, solution2].sort, SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "does not select solutions you already mentor" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution
    create :solution_mentorship, user: mentor, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "does not select solutions claimed by a mentor" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution1 = create(:solution,
                          exercise: create(:exercise, track: track),
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution2 = create(:solution,
                           exercise: create(:exercise, track: track),
                           user: mentee,
                           mentoring_requested_at: Time.current)

    create :iteration, solution: bad_solution
    create :iteration, solution: good_solution1
    create :iteration, solution: good_solution2

    # Lock with a differnet mentor
    create :solution_lock, solution: bad_solution, user: create(:user), locked_until: Time.now + 1.day

    # Lock with the same mentor
    create :solution_lock, solution: good_solution1, user: mentor, locked_until: Time.now + 1.day

    assert_equal [good_solution1, good_solution2], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "does not select solutions that haven't requested mentoring" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          user: mentee,
                          mentoring_requested_at: nil)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "filters by track" do
    mentor, track1 = create_mentor_and_track
    track2 = create :track
    create :track_mentorship, user: mentor, track: track2
    mentee = create_mentee([track1, track2])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track2),
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track1),
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, [track1.id], nil).all_side_solutions.sort
  end

  test "filters by exercise" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_exercise = create(:exercise, track: track)
    good_exercise = create(:exercise, track: track)
    bad_solution = create(:solution,
                          exercise: bad_exercise,
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: good_exercise,
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, [good_exercise.id]).all_side_solutions.sort
  end

  test "only selects solutions that have an iteration" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort

  end

  test "does not select solutions with >=3 mentors" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    # Temporary change: >=3 to >=1
    # For >=3 mentors, change the values below to 1 and 0 respective
    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          num_mentors: 1,
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           num_mentors: 0,
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end


  test "does not select solutions from inactive users" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    inactive_user = create_mentee([track])
    active_user = create_mentee([track])
    inactive_user.update(current_sign_in_at: Date.today - 65.days)
    active_user.update(current_sign_in_at: Date.today - 55.days)

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          user: inactive_user,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           user: active_user,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "does not select approved solutions" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          approved_by: create(:user),
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           approved_by: nil,
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "does not select completed solutions" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          completed_at: DateTime.now - 1.minute,
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           completed_at: nil,
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "does not select ignored solutions" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    bad_solution = create(:solution,
                          exercise: create(:exercise, track: track),
                          user: mentee,
                          mentoring_requested_at: Time.current)
    good_solution = create(:solution,
                           exercise: create(:exercise, track: track),
                           user: mentee,
                           mentoring_requested_at: Time.current)
    create :iteration, solution: good_solution
    create :iteration, solution: bad_solution
    create :ignored_solution_mentorship, solution: bad_solution, user: mentor

    assert_equal [good_solution], SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.sort
  end

  test "filters correctly" do
    Timecop.freeze do
      mentor, track = create_mentor_and_track
      independent_user = create :user
      mentored_user = create :user
      core_exercise = create(:exercise, track: track, core: true)
      side_exercise = create(:exercise, track: track, core: false)

      independent_core_solution = create(:solution,
                                    exercise: create(:exercise, track: track, core: true),
                                    num_mentors: 0,
                                    user: independent_user,
                                    track_in_independent_mode: true,
                                    mentoring_requested_at: Time.current)

      independent_side_solution = create(:solution,
                                    exercise: create(:exercise, track: track, core: false),
                                    num_mentors: 0,
                                    user: independent_user,
                                    track_in_independent_mode: true,
                                    mentoring_requested_at: Time.current)


      unmentored_core_solution = create(:solution,
                                        exercise: create(:exercise, track: track, core: true),
                                        num_mentors: 0,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current - 1.minute,)

      unmentored_core_solution_2 = create(:solution,
                                        exercise: create(:exercise, track: track, core: true),
                                        num_mentors: 0,
                                        created_at: Exercism::V2_MIGRATED_AT,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current)

      unmentored_side_solution = create(:solution,
                                        exercise: create(:exercise, track: track, core: false),
                                        num_mentors: 0,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current)

      mentored_1_core_solution = create(:solution,
                                        exercise: create(:exercise, track: track, core: true),
                                        num_mentors: 1,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current - 10.minutes)

      mentored_2_core_solution = create(:solution,
                                        exercise: create(:exercise, track: track, core: true),
                                        num_mentors: 2,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current)

      old_unmentored_core_solution = create(:solution,
                                        exercise: create(:exercise, track: track, core: true),
                                        num_mentors: 0,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current - 1.day)

      all_solutions = [
        independent_core_solution,
        independent_side_solution,
        old_unmentored_core_solution,
        unmentored_core_solution,
        unmentored_side_solution,
        mentored_1_core_solution,
        mentored_2_core_solution,
        unmentored_core_solution_2
      ]

      all_solutions.each do |solution|
        create :iteration, solution: solution
      end

      assert_equal [old_unmentored_core_solution, unmentored_core_solution, unmentored_core_solution_2].map(&:id),
                    SolutionsToBeMentored.new(mentor, nil, nil).mentored_core_solutions.map(&:id)

      assert_equal [unmentored_side_solution].map(&:id),
                   SolutionsToBeMentored.new(mentor, nil, nil).mentored_side_solutions.map(&:id)

      assert_equal [old_unmentored_core_solution, unmentored_core_solution, unmentored_core_solution_2, independent_core_solution].map(&:id),
                   SolutionsToBeMentored.new(mentor, nil, nil).all_core_solutions.map(&:id)

      assert_equal [unmentored_side_solution, independent_side_solution].map(&:id),
                   SolutionsToBeMentored.new(mentor, nil, nil).all_side_solutions.map(&:id)

      assert_equal [independent_core_solution, independent_side_solution].map(&:id),
                   SolutionsToBeMentored.new(mentor, nil, nil).independent_solutions.map(&:id)
    end
  end

  test "index_of_core_solution" do
    mentor, track = create_mentor_and_track

    # 10 old core solutions
    10.times.map do |idx|
      create(:solution,
         exercise: create(:exercise, track: track, core: true),
         mentoring_requested_at: (Time.current - 30.minutes) + idx.minutes
      ).tap do |solution|
        create :iteration, solution: solution
      end
    end

    # 10 same-exercise solutions
    exercise = create(:exercise, track: track, core: true)
    solutions = 10.times.map do |idx|
      create(:solution,
         exercise: exercise,
         mentoring_requested_at: (Time.current - 10.minutes) + idx.minutes
      ).tap do |solution|
        create :iteration, solution: solution
      end
    end

    expected = {
      track: 15,
      exercise: 5
    }
    assert_equal expected, SolutionsToBeMentored.index_of_core_solution(solutions[4])

    # Add Non-core
    create(:solution,
      exercise: create(:exercise, track: track, core: false),
      mentoring_requested_at: Time.current - 15.minutes
    ).tap {|s| create :iteration, solution: s}
    assert_equal expected, SolutionsToBeMentored.index_of_core_solution(solutions[4])

    # Add independent
    create(:solution,
      exercise: exercise,
      track_in_independent_mode: true,
      mentoring_requested_at: Time.current - 15.minutes
    ).tap {|s| create :iteration, solution: s}
    assert_equal expected, SolutionsToBeMentored.index_of_core_solution(solutions[4])
end

  def create_mentor_and_track
    mentor = create :user
    track = create :track
    create :track_mentorship, user: mentor, track: track
    [mentor, track]
  end

  def create_mentee(tracks)
    mentee = create(:user)
    tracks.each { |track| create(:user_track, track: track, user: mentee) }

    mentee
  end
end

