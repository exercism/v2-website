require 'test_helper'

class SetSolutionsIndependentModeTest < ActiveSupport::TestCase
  test "it populates correctly" do

    ruby = create :track
    python = create :track
    user = create :user
    create :user_track, user: user, track: ruby

    normal_solution = create :solution, user: user, exercise: create(:exercise, track: ruby)
    independent_solution = create :solution, user: user, exercise: create(:exercise, track: python), independent_mode: true

    ActiveRecord::Base.connection.execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id
      SET solutions.independent_mode = user_tracks.independent_mode
      WHERE completed_at IS NOT NULL
    })

    [normal_solution, independent_solution].each(&:reload)
    refute normal_solution.independent_mode?
    assert independent_solution.independent_mode?
  end
end
