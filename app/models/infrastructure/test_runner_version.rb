class Infrastructure::TestRunnerVersion < ApplicationRecord
  belongs_to :test_runner

  enum status: [:pending, :building, :built, :deploying, :deployed, :tested, :live, :retired]

  after_create do
    build!
  end

  def self.deployed_tested_or_live
    where(status: [:deployed, :testing, :live])
  end

  def self.not_retired
    where.not(status: :retired)
  end

  def build!
    RestClient.post("#{orchestrator_url}/languages/#{test_runner.language_slug}/versions", {
      version: { slug: slug },
    })
    update(status: :building)
  end

  def deploy!
    test_runner.deploy_versions!(append_new_version: slug)
    update(status: :deploying)
  end

  def promote!
    test_runner.update(version_slug: slug)

    RestClient.post("#{orchestrator_url}/languages/#{test_runner.language_slug}", {
      settings: {
        timeout_ms: test_runner.timeout_ms,
        version_slug: test_runner.version_slug,
        num_processors: test_runner.num_processors
      },
    })

    ActiveRecord::Base.connection.transaction do
      test_runner.versions.live.update_all(status: :tested)
      update(status: :live)
    end
  end

  def samples_uuid_prefix
    "internal-test-runner-version-#{slug}-"
  end

  private
  def orchestrator_url
    Rails.application.secrets.test_runner_orchestrator_url
  end
end
