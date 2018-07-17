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
      core_exercises = track.exercises.core.order("position ASC")
      core_exercise_ids = core_exercises.map(&:id)
      side_exercises = track.exercises.side
      unlocked_by, auto_unlock = side_exercises.partition { |e| e.unlocked_by_id.present? }

      UserTrack.includes(:user).where(track_id: track.id).each do |ut|
        user = ut.user

=begin
        # Get core exercises for checking
        existing_core_ids = Solution.joins(:exercise).where('exercises.core': true).where(user_id: ut.user_id, "exercises.track_id": ut.track_id).pluck(:exercise_id)

        # If there are *no* core solutions on the track
        # then we want to unlock the first core exercise (normally hello-world).
        # This does not guarantee that someone will have an unlocked exercise
        # as they may have completed a core exercise and not unlocked another in
        # its place, but this means that there will be one solution that is
        # either unlocked or completed.
        #
        # Do this before getting the other stuff
        #if existing_core_ids.empty?
        #  CreatesSolution.create!(user, core_exercises.first)
        #  existing_core_ids << core_exercises.first.id
        #end
=end

        # Get core ids and unlocked core ids
        existing_core_exercises = Solution.joins(:exercise).where('exercises.core': true).where(user_id: ut.user_id, "exercises.track_id": ut.track_id)
        existing_core_ids = existing_core_exercises.pluck(:exercise_id)
        existing_unlocked_core_ids = existing_core_exercises.where(completed_at: nil).pluck(:exercise_id)

        # We want to ensure there is one core exercise unlocked
        # If there are currently none, we go through each in order and
        # as soon as we find an exercise that has no solution which is
        # unlocked but not completed we create a solution for that and break.
        if existing_unlocked_core_ids.empty?
          core_exercises.each do |core_exercise|
            next if existing_core_ids.include?(core_exercise.id)
            CreatesSolution.create!(user, core_exercise)
            break
          end
        end

        # Get side exercises for checking
        existing_completed_exercise_ids = Solution.joins(:exercise).where(user_id: ut.user_id, "exercises.track_id": ut.track_id).completed.pluck(:exercise_id)
        existing_uncompleted_exercise_ids = Solution.joins(:exercise).where(user_id: ut.user_id, "exercises.track_id": ut.track_id).not_completed.pluck(:exercise_id)
        existing_exercise_ids = existing_completed_exercise_ids + existing_uncompleted_exercise_ids

        # Unlock auto unlocks
        auto_unlock.each do |side_exercise|
          unless existing_exercise_ids.include?(side_exercise.id)
            CreatesSolution.create!(user, side_exercise)
          end
        end

        # Unlock unlocked side exercsies
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
