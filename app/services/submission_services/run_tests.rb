module SubmissionServices
  class RunTests
    include Mandate

    initialize_with :uuid, :solution

    def call
      RestClient.post "#{orchestrator_url}/submissions", {
        track_slug: solution.exercise.track.slug,
        exercise_slug: solution.exercise.slug,
        submission_uuid: uuid
      }
    end

    private

    def orchestrator_url
      Rails.application.secrets.test_runner_orchestrator_url
    end
  end
end

