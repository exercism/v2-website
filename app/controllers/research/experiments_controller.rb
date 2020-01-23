module Research
  class ExperimentsController < Research::BaseController
    skip_before_action :authenticate_user!
    skip_before_action :check_user_joined_research!

    def index
      return redirect_to(action: :show, id: Experiment.first.id)

      #@experiments = Experiment.all
      #@user_experiments_by_ids = current_user.research_experiments.each_with_object({}) {|ue,h|
      #  h[ue.experiment_id] = ue
      #}
    end

    def show
      @experiment = Experiment.find(params[:id])
      @user_experiment = current_user.research_experiments.where(experiment_id: @experiment.id).first
    end
  end
end
