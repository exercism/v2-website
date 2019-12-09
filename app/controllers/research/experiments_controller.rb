module Research
  class ExperimentsController < Research::BaseController
    skip_before_action :authenticate_user!
    skip_before_action :check_user_joined_research!

    def index
      @experiments = Experiment.all
      @user_experiments_by_ids = current_user.research_experiments.each_with_object({}) {|ue,h|
        h[ue.experiment_id] = ue
      }
    end

    def show
      @experiment = Experiment.find(params[:id])
    end
  end
end
