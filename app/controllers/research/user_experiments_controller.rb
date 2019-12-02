module Research
  class UserExperimentsController < Research::BaseController
    before_action :set_user_experiment, except: [:create]

    def create
      experiment = Experiment.find(params[:experiment_id])
      user_experiment = CreateUserExperiment.(current_user, experiment)
      redirect_to research_user_experiment_path(user_experiment)
    end

    def show
      @languages = {
        ruby: "Ruby",
        csharp: "C#"
      }
    end

    def language
      @language_track = Track.find_by_slug!(params[:language])
    end

    private
    def set_user_experiment
      @experiment = Experiment.find(params[:id])
      @user_experiment = UserExperiment.find_by(user: current_user, experiment: @experiment)
    end
  end
end
