module SubmissionServices
  class RunTests
    include Mandate

    initialize_with :uuid, :solution

    def call
      RestClient.post "#{orchestrator_url}/submissions", {
        submission_uuid: uuid,
        language_slug: solution.exercise.language_track.slug,
        exercise_slug: solution.exercise.slug
      }
    end

    private

    def orchestrator_url
      Rails.application.secrets.test_runner_orchestrator_url
    end
  end
end

