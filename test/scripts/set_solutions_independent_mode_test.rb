require 'test_helper'

class SetSolutionsIndependentModeTest < ActiveSupport::TestCase
  test "it populates correctly" do

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

    # Set old things to independent mode if they've not requested mentorin
    ActiveRecord::Base.connection.execute(%Q{
      UPDATE solutions
      SET solutions.independent_mode = 1
      WHERE solutions.created_at <= "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND mentoring_enabled = 0 OR mentoring_enabled IS NULL
    })

    # Set old things to mentored mode if they're requested mentorin
    ActiveRecord::Base.connection.execute(%Q{
      UPDATE solutions
      SET solutions.independent_mode = 0
      WHERE solutions.created_at <= "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND mentoring_enabled = 1
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
