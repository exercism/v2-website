class CacheTrackInIndependentMode < ActiveRecord::Migration[5.2]
  def up
    # Update solutions.track_in_independent_mode
    execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id

      SET solutions.track_in_independent_mode = COALESCE(user_tracks.independent_mode, 1)
    })

    # Set old things to independent mode if they've not requested mentoring
    execute(%Q{
      UPDATE solutions
      SET solutions.independent_mode = 1
      WHERE solutions.created_at <= "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND mentoring_enabled = 0 OR mentoring_enabled IS NULL
    })

    # Set old things to mentored mode if they're requested mentoring
    execute(%Q{
      UPDATE solutions
      SET solutions.independent_mode = 0
      WHERE solutions.created_at <= "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND mentoring_enabled = 1
    })

    # Set new things to independent_mode if they've not chosen yet
    execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id

      SET solutions.independent_mode = 1
      WHERE solutions.created_at > "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND user_tracks.independent_mode IS NULL
    })

    # Set new things to opposite of mentoring requested if they're in independent
    execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id

      SET solutions.independent_mode = COALESCE(!mentoring_enabled, 1)
      WHERE solutions.created_at > "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND user_tracks.independent_mode = 1
    })

    # Set new things to mentored_mode if they're in normal
    execute(%Q{
      UPDATE solutions
      JOIN exercises ON solutions.exercise_id = exercises.id
      JOIN user_tracks ON solutions.user_id = user_tracks.user_id
                      AND exercises.track_id = user_tracks.track_id

      SET solutions.independent_mode = 0
      WHERE solutions.created_at > "#{Exercism::V2_MIGRATED_AT.to_s(:db)}"
      AND user_tracks.independent_mode = 0
    })
  end

  def down
  end
end
