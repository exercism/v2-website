module Flux
  class MergeJSAndECMA
    include Mandate

    JS_SHA = "6a8a5a41b89a45008b46ca18ff7ea800baca1c4c"

    def call
      lock_js_shas
      repoint_solutions
      rename_js_exercises
      update_tracks
      creates_track_mentorships
      fix_unlocking
    end

    private

    def lock_js_shas
      Solution.where(exercise_id: js.exercises).update_all(git_sha: JS_SHA)
    end

    def repoint_solutions
      # Delete any unstarted ecma exercises
      Solution.where(exercise_id: ecma.exercises).not_started.delete_all

      # Delete any unstarted js exercises
      Solution.where(exercise_id: js.exercises).not_started.delete_all

      ecma_user_id_slugs = Solution.where(exercise_id: ecma.exercises).includes(:exercise).map{|s|"#{s.user_id}_#{s.exercise.slug}"}
      js_solutions = Solution.where(exercise_id: js.exercises).started.includes(:exercise)

      js_solutions.each do |solution|
        if ecma_user_id_slugs.include?("#{solution.user_id}_#{solution.exercise.slug}")
          solution.update(
            approved_by_id: 1, # Migration bot
            completed_at: Exercism::JS_AND_ECMA_MERGED_AT
          )
        else
          solution.update(
            exercise_id: ecma_exercises_mapping[solution.exercise.slug]
          )
        end
      end
    end

    def rename_js_exercises
      js.exercises.each do |exercise|
        exercise.update(
          slug: "legacy-#{exercise.slug}",
          title: "#{exercise.title} (Legacy)",
          track: ecma
        )
      end
    end

    def fix_unlocking
      UserTrack.where(track: js).find_each do |user_track|
        if UserTrack.where(track: ecma, user_id: user_track.user_id).exists?
          user_track.destroy
        else
          user_track.update(track: ecma)
        end
      end

      UserTrack.where(track: ecma).find_each do |user_track|
        FixUnlockingInUserTrack.(user_track)
      end
    end

    def update_tracks
      js.update(
        title: "JavaScript (Legacy)", 
        slug: "javascript-legacy",
        active: false
      )
      ecma.update(title: "JavaScript", slug: "javascript")
    end

    def creates_track_mentorships
      ecma_mentor_user_ids = TrackMentorship.where(track_id: ecma.id).pluck(:user_id)
      TrackMentorship.where(track: js).each do |mentorship|
        if ecma_mentor_user_ids.include?(mentorship.user_id)
          mentorship.destroy
        else
          mentorship.update(track_id: ecma.id)
        end
      end
    end

    memoize
    def js_exercises_mapping
      js.exercises.pluck(:slug, :id).each_with_object({}) {|(slug,id),hsh|
        hsh[slug] = id
      }
    end

    memoize
    def ecma_exercises_mapping
      ecma.exercises.pluck(:slug, :id).each_with_object({}) {|(slug,id),hsh|
        hsh[slug] = id
      }
    end

    memoize
    def js
      Track.find_by_slug("javascript")
    end

    memoize
    def ecma
      Track.find_by_slug("ecmascript")
    end
  end
end
