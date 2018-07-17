module Scripts
  class FixETLUnlocking
    include Mandate

    def call
      Track.all.each do |track|
        fix_track(track)
      end
    end

    # Note: This doesn't take into consideration exercises 
    # completed without approval. That should be added before 
    # this is run in the future.
    def fix_track(track)
      side_exercises = track.exercises.side
      unlocked_by, auto_unlock = side_exercises.partition { |e| e.unlocked_by_id }

      UserTrack.includes(:user).where(track_id: track.id).each do |ut|
        user = ut.user

        existing_completed_exercise_ids = Solution.joins(:exercise).where(user_id: ut.user_id, "exercises.track_id": ut.track_id).completed.pluck(:exercise_id)
        existing_uncompleted_exercise_ids = Solution.joins(:exercise).where(user_id: ut.user_id, "exercises.track_id": ut.track_id).not_completed.pluck(:exercise_id)
        existing_exercise_ids = existing_completed_exercise_ids + existing_uncompleted_exercise_ids

        auto_unlock.each do |side_exercise|
          unless existing_exercise_ids.include?(side_exercise.id)
            CreatesSolution.create!(user, side_exercise)
          end
        end

        unlocked_by.each do |side_exercise|
          if !existing_exercise_ids.include?(side_exercise.id) &&
             existing_completed_exercise_ids.include?(side_exercise.unlocked_by_id)
            CreatesSolution.create!(user, side_exercise)
          end
        end
      end
    end
  end
end
