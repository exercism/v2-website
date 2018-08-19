module Flux
  class MergeJSAndECMA
    include Mandate

    JS_SHA = "6a8a5a41b89a45008b46ca18ff7ea800baca1c4c"

    def call
      return
      repoint_solutions
      rename_js_exercises
      fix_unlocking
    end

    private

    #js_user_id_slugs = Solution.where(exercise_id: js.exercises).started.includes(:exercise).map{|s|"#{s.user_id}_#{s.exercise.slug}"}
    def repoint_solutions
      js_exercise_mapping.each do |slug, id|
        ecma_exercise_id = ecma_exercise_mapping[slug]
        Solution.where(exercise_id: id).update_all(
          exercise_id: ecma_exercise_id,
          git_sha: JS_SHA
        )
      end
    end

    def rename_js_exercises
      js.exercises.each do |exercise|
        exercise.update(
          slug: "legacy-#{exercise.slug}",
          title: "#{exercise.title} (Legacy)"
        )
      end
    end

    def fix_unlocking
      #FixUnlockingInUserTrack.()
    end

    memoize
    def js_exercise_mapping
      js.exercises.pluck(:slug, :id).each_with_object({}) {|(slug,id),hsh|
        hsh[slug] = id
      }
    end

    memoize
    def ecma_exercise_mapping
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
