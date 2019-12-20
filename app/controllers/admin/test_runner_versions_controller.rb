class Admin::TestRunnerVersionsController < AdminController
  before_action :restrict_to_admins!, except: [:index]
  before_action :set_test_runner

  def show
    @version = @test_runner.versions.find(params[:id])

    InfrastructureServices::UpdateBuiltVersions.(@test_runner)
  end

  def new
    @version = @test_runner.versions.build
  end

  def create
    @version = @test_runner.versions.create(params.require(:infrastructure_test_runner_version).permit!)
    RestClient.post("#{orchestrator_url}/languages/#{@test_runner.language_slug}/versions", {
      version: {
        slug: @version.slug,
      },
    })
    @version.update(status: :building)

    redirect_to action: :show, id: @version
  end

  def deploy
    @version = @test_runner.versions.find(params[:id])
    RestClient.patch("#{orchestrator_url}/languages/#{@test_runner.language_slug}/versions/#{@version.slug}/deploy", {})
    @version.update(status: :deploying)

    redirect_to action: :show, id: @version
  end

  def promote
    @version = @test_runner.versions.find(params[:id])
    @test_runner.update(version_slug: @version.slug)

    RestClient.post("#{orchestrator_url}/languages/#{@test_runner.language_slug}", {
      settings: {
        timeout_ms: @test_runner.timeout_ms,
        container_slug: @test_runner.version_slug,
        num_processors: @test_runner.num_processors
      },
    })
    ActiveRecord::Base.connection.transaction do
      @test_runner.versions.live.update_all(status: :tested)
      @version.update(status: :live)
    end

    redirect_to action: :show, id: @version
  end

  private
  def set_test_runner
    @test_runner = Infrastructure::TestRunner.find(params[:test_runner_id])
  end

  def orchestrator_url
    Rails.application.secrets.test_runner_orchestrator_url
  end
end

