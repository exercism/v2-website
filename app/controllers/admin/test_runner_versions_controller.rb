class Admin::TestRunnerVersionsController < AdminController
  before_action :restrict_to_admins!, except: [:index]
  before_action :set_test_runner

  def show
    @version = @test_runner.versions.find(params[:id])
    @test_results = {}

    InfrastructureServices::UpdateBuiltTestRunnerVersions.(@test_runner)
  end

  def new
    @version = @test_runner.versions.build
  end

  def create
    @version = @test_runner.versions.create(params.require(:infrastructure_test_runner_version).permit!)

    redirect_to action: :show, id: @version
  end

  def deploy
    @version = @test_runner.versions.find(params[:id])
    @version.deploy!

    redirect_to action: :show, id: @version
  end

  def promote
    @version = @test_runner.versions.find(params[:id])
    @version.promote!

    redirect_to action: :show, id: @version
  end

  def retire
    @version = @test_runner.versions.find(params[:id])
    @test_runner.deploy_versions!
    @version.update(status: :retired)

    redirect_to action: :show, id: @version
  end

  def test
    @version = @test_runner.versions.find(params[:id])
    @test_results = {
      solution_uuid: params[:solution_uuid]
    }
    render action: :show
  end

  private
  def set_test_runner
    @test_runner = Infrastructure::TestRunner.find(params[:test_runner_id])
  end
end

