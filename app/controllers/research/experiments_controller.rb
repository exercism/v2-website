module Research
  class ExperimentsController < Research::BaseController
    skip_before_action :authenticate_user!
    skip_before_action :check_user_joined_research!

    def index
      @experiments = Experiment.all
    end

    def show
      @experiment = Experiment.find(params[:id])
    end
  end
end
