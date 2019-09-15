require 'test_helper'

class SetSolutionsIndependentModeTest < ActiveSupport::TestCase
  test "fix it" do
    skip
    incorrectly_independent_solution_1 = create :solution, independent_mode: true, track_in_independent_mode: false
    incorrectly_independent_solution_2 = create :solution, independent_mode: true, track_in_independent_mode: false
    create :iteration, solution: incorrectly_independent_solution_2

    correctly_independent_solution = create :solution, independent_mode: true, track_in_independent_mode: false, completed_at: Time.now - 1.day
    create :iteration, solution: correctly_independent_solution

    Solution.where('independent_mode = 1 and track_in_independent_mode = 0').
             not_completed.
             update_all('independent_mode = 0')

    [
      incorrectly_independent_solution_1,
      incorrectly_independent_solution_2,
      correctly_independent_solution
    ].each(&:reload)

    refute incorrectly_independent_solution_1.independent_mode?
    refute incorrectly_independent_solution_2.independent_mode?
    assert correctly_independent_solution.independent_mode?
  end

  test "it populates correctly" do
    skip

    # Delete on Sept 1st 2018
    #skip "Kept for posterity"

    independent_track = create :track
    mentored_track = create :track
    undecided_track = create :track
    user = create :user
    create :user_track, user: user, track: independent_track, independent_mode: true
    create :user_track, user: user, track: mentored_track, independent_mode: false
    create :user_track, user: user, track: undecided_track, independent_mode: nil

    legacy_solution = create :solution, user: user, exercise: create(:exercise, track: mentored_track), created_at: Exercism::V2_MIGRATED_AT - 1.week
    legacy_undecided_solution = create :solution, user: user, exercise: create(:exercise, track: undecided_track), created_at: Exercism::V2_MIGRATED_AT - 1.week
    legacy_but_requested_solution = create :solution, user: user, exercise: create(:exercise, track: mentored_track), created_at: Exercism::V2_MIGRATED_AT - 1.week, mentoring_enabled: true

    independent_solution = create :solution, user: user, exercise: create(:exercise, track: independent_track)
    independent_but_requested_solution = create :solution, user: user, exercise: create(:exercise, track: independent_track), mentoring_enabled: true
    mentored_solution = create :solution, user: user, exercise: create(:exercise, track: mentored_track)
    undecided_solution = create :solution, user: user, exercise: create(:exercise, track: undecided_track)

    # Set old things to independent mode if they've not requested mentoring
    ActiveRecord::Base.connection.execute(%Q{
      UPDATE solutions
      SET solutions.independent_mode = COALESCE(!mentoring_enabled, 1)
      WHERE solutions.created_at <= "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
    })

    # Set new things to independent_mode if they've not chosen yet
    ActiveRecord::Base.connection.execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id

      SET solutions.independent_mode = 1
      WHERE solutions.created_at > "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND user_tracks.independent_mode IS NULL
    })

    # Set new things to opposite of mentoring requested if they're in independent
    ActiveRecord::Base.connection.execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id

      SET solutions.independent_mode = COALESCE(!mentoring_enabled, 1)
      WHERE solutions.created_at > "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND user_tracks.independent_mode = 1
    })

    # Set new things to mentored_mode if they're in normal
    ActiveRecord::Base.connection.execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id

      SET solutions.independent_mode = 0
      WHERE solutions.created_at > "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND user_tracks.independent_mode = 0
    })

    [legacy_solution, legacy_undecided_solution, legacy_but_requested_solution,
     independent_solution, independent_but_requested_solution, mentored_solution,
     undecided_solution].each(&:reload)

    assert legacy_solution.independent_mode?
    assert legacy_undecided_solution.independent_mode?
    refute legacy_but_requested_solution.independent_mode?
    assert independent_solution.independent_mode?
    refute independent_but_requested_solution.independent_mode?
    refute mentored_solution.independent_mode?
    assert undecided_solution.independent_mode?
  end
end
