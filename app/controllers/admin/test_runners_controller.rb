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

  def show
    @test_runner = Infrastructure::TestRunner.find(params[:id])
    InfrastructureServices::UpdateBuiltTestRunnerVersions.(@test_runner)
  end

  def new
    @test_runner = Infrastructure::TestRunner.new
  end

  def edit
    @test_runner = Infrastructure::TestRunner.find(params[:id])
  end

  def create
    @test_runner = Infrastructure::TestRunner.create!(params.require(:infrastructure_test_runner).permit!)

    redirect_to action: :index
  end

  def update
    @test_runner = Infrastructure::TestRunner.find(params[:id])
    @test_runner.update!(params.require(:infrastructure_test_runner).permit!)
    redirect_to action: :index
  end

  private
  def orchestrator_url
    Rails.application.secrets.test_runner_orchestrator_url
  end

end
