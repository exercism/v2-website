class PopulateIndependentModeOnSolutions < ActiveRecord::Migration[5.2]
  def up
    execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id
      SET solutions.independent_mode = COALESCE(user_tracks.independent_mode, FALSE)
    })
  end

  def down
  end
end
