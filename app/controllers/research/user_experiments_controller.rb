module Research
  class UserExperimentsController < Research::BaseController
    def create
      experiment = Experiment.find(params[:experiment_id])
      begin
        UserExperiment.create!(
          user: current_user,
          experiment: experiment
        )
      rescue ActiveRecord::RecordNotUnique
      end
      redirect_to research_user_experiment_path(experiment)
    end

    def show
      @experiment = Experiment.find(params[:id])
      @user_experiment = UserExperiment.find_by(user: current_user, experiment: @experiment)
    end
  end
end
