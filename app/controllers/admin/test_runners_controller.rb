class Admin::TestRunnersController < AdminController
  before_action :restrict_to_admins!, except: [:index]

  def index
    @test_runners = Infrastructure::TestRunner.all
    @orchestrator_status = HashWithIndifferentAccess.new(
      JSON.parse(
        RestClient.get("#{orchestrator_url}/status")
      )
    )
  end

  def new
    @test_runner = Infrastructure::TestRunner.new
  end

  def edit
    @test_runner = Infrastructure::TestRunner.find(params[:id])
  end

  def create
    Infrastructure::TestRunner.create!(params.require(:infrastructure_test_runner).permit!)
    redirect_to action: :index
  end

  def update
    @test_runner = Infrastructure::TestRunner.find(params[:id])
    @test_runner.update(params.require(:infrastructure_test_runner).permit!)
    RestClient.patch("#{orchestrator_url}/languages/#{@test_runner.language_slug}/settings", {
      settings: {
        timeout_ms: @test_runner.timeout_ms,
        container_slug: @test_runner.container_slug
      }
    })
    RestClient.patch("#{orchestrator_url}/languages/#{@test_runner.language_slug}/scale/#{@test_runner.num_processors}", {})
    redirect_to action: :index
  end

  private
  def orchestrator_url
    Rails.application.secrets.test_runner_orchestrator_url
  end

end
