class Infrastructure::TestRunner < ApplicationRecord
  has_many :versions, class_name: "TestRunnerVersion"

  before_create do
    self.num_processors = 0 unless self.num_processors
  end

  after_create do
    RestClient.post("#{orchestrator_url}/languages/#{language_slug}", {
      settings: {
        timeout_ms: timeout_ms,
        version_slug: version_slug,
        num_processors: num_processors
      },
    })
  end

  after_update do
    RestClient.patch("#{orchestrator_url}/languages/#{language_slug}/settings", {
      settings: {
        timeout_ms: timeout_ms,
        version_slug: version_slug
      }
    })
    RestClient.patch("#{orchestrator_url}/languages/#{language_slug}/scale/#{num_processors}", {})
  end

  def deploy_versions!(append_new_version: nil)
    slugs = versions.deployed_tested_or_live.map(&:slug)
    slugs << append_new_version if append_new_version
    RestClient.patch("#{orchestrator_url}/languages/#{language_slug}/versions/deploy", {
      version_slugs: slugs
    })
  end

  private
  def orchestrator_url
    Rails.application.secrets.test_runner_orchestrator_url
  end

end
