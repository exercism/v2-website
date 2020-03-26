module Research
  class ExperimentsController < Research::BaseController
    skip_before_action :authenticate_user!
    #skip_before_action :check_user_joined_research!

    def index
      return redirect_to(action: :show, id: Experiment.first.id)
    end

    def show
      @experiment = Experiment.find(params[:id])
      @user_experiment = current_user ?
                           current_user.research_experiments.where(experiment_id: @experiment.id).first :
                           nil
    end
  end
end
