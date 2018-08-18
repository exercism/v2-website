module Flux
  class MergeJSAndECMA
    include Mandate

    JS_SHA = "6a8a5a41b89a45008b46ca18ff7ea800baca1c4c"

    def call

      js_exercise_mapping.each do |slug, id|
        ecma_exercise_id = ecma_exercise_mapping[slug]
        Solution.where(exercise_id: id).update_all(
          exercise_id: ecma_exercise_id,
          git_sha: JS_SHA
        )
      end

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
