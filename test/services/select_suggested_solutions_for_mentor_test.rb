require 'test_helper'

class SelectSuggestedSolutionsForMentorTest < ActiveSupport::TestCase
  test "puts exercises in standard mode first" do
    mentor = create(:user)
    mentee = create(:user)
    track = create(:track)
    create(:track_mentorship, user: mentor, track: track)

    standard_exercise = create(:exercise, track: track)
    standard_solution = create(:solution, 
                               exercise: standard_exercise, 
                               user: mentee, 
                               track_in_independent_mode: false,
                               mentoring_requested_at: Time.current)

    independent_exercise = create(:exercise, track: track)
    independent_solution = create(:solution,
                                  exercise: independent_exercise,
                                  user: mentee,
                                  track_in_independent_mode: true,
                                  mentoring_requested_at: Time.current)

    [standard_solution, independent_solution].each do |solution|
      create :iteration, solution: solution
    end

    expected = [standard_solution, independent_solution]
    actual = SelectSuggestedSolutionsForMentor.(mentor)
    assert_equal expected.map(&:id), actual.map(&:id)
  end

  test "puts core exercises first" do
    mentor, track = create_mentor_and_track
    mentee = create_mentee([track])

    side_solution = create(:solution,
                           exercise: create(:exercise, track: track, core: false),
                           user: mentee,
                           mentoring_requested_at: Time.current)
    core_solution = create(:solution,
                           exercise: create(:exercise, track: track, core: true),
                           user: mentee,
                           mentoring_requested_at: Time.current)
    [core_solution, side_solution].each do |solution|
      create :iteration, solution: solution
    end

    assert_equal(
      [core_solution, side_solution],
      SelectSuggestedSolutionsForMentor.(mentor)
    )
  end

  test "orders correctly" do
    Timecop.freeze do
      mentor, track = create_mentor_and_track
      independent_user = create :user
      mentored_user = create :user
      core_exercise = create(:exercise, track: track, core: true)
      side_exercise = create(:exercise, track: track, core: false)

      independent_solution = create(:solution,
                                    exercise: create(:exercise, track: track, core: true),
                                    num_mentors: 0,
                                    user: independent_user,
                                    track_in_independent_mode: true,
                                    mentoring_requested_at: Time.current)

      unmentored_core_solution = create(:solution,
                                        exercise: create(:exercise, track: track, core: true),
                                        num_mentors: 0,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current - 1.minute)

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
                                        last_updated_by_user_at: Time.current - 1.day,
                                        user: mentored_user,
                                        mentoring_requested_at: Time.current - 1.day)

      [
        independent_solution,
        old_unmentored_core_solution,
        unmentored_core_solution,
        unmentored_side_solution,
        mentored_1_core_solution,
        mentored_2_core_solution,
        unmentored_core_solution_2
      ].each do |solution|
        create :iteration, solution: solution
      end

      expected = [
        old_unmentored_core_solution,
        unmentored_core_solution,
        unmentored_core_solution_2,
        unmentored_side_solution,
        independent_solution,

        # We are currently not showing any solutions
        # with >=1 mentor. Uncomment these again when/if
        # we change this back to >=3 mentors.
        #mentored_1_core_solution,
        #mentored_2_core_solution,
      ]
      actual = SelectSuggestedSolutionsForMentor.(mentor)

      assert_equal expected.map(&:id), actual.map(&:id)
    end
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
