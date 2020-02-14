module InfrastructureServices
  class UpdateDeployedTestRunnerVersions
    include Mandate

    initialize_with :test_runner

    def call
      test_runner.versions.deploying.each do |version|
        next unless deployed_versions.include?(version.slug)

        # Only allow deploying -> deployed through this method
        Infrastructure::TestRunnerVersion.where(id: version.id, status: :deploying).
                                           update_all(status: :deployed)
      end
    end

    memoize
    def deployed_versions
      json = RestClient.get("#{orchestrator_url}/languages/#{test_runner.language_slug}/versions/deployed")
      hash = HashWithIndifferentAccess.new(JSON.parse(json))
      hash[:version_slugs]
    end

    private
    def orchestrator_url
      Rails.application.secrets.test_runner_orchestrator_url
    end
  end
end

