module SubmissionServices
  class RunTests
    include Mandate

    initialize_with :uuid, :solution

    def call
      RestClient.post 'http://localhost:9292/submissions', {
        track_slug: solution.exercise.track.slug,
        exercise_slug: solution.exercise.slug,
        submission_uuid: uuid
      }
    end
  end
end

