module SubmissionServices
  class RunTests
    include Mandate

    def initialize(uuid, solution, version_slug = nil)
      @uuid = uuid
      @solution = solution
      @version_slug = version_slug
    end

    def call
      RestClient.post "#{orchestrator_url}/submissions", {
        submission_uuid: uuid,
        language_slug: solution.exercise.language_track.slug,
        exercise_slug: solution.exercise.slug,
        version_slug: version_slug
      }
    end

    private
    attr_reader :uuid, :solution, :version_slug

    def orchestrator_url
      Rails.application.secrets.test_runner_orchestrator_url
    end
  end
end

