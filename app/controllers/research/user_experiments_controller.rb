module Research
  class UserExperimentsController < Research::BaseController
    before_action :set_user_experiment, except: [:create]

    def create
      experiment = Experiment.find(params[:experiment_id])
      user_experiment = CreateUserExperiment.(current_user, experiment)
      redirect_to research_user_experiment_path(user_experiment)
    end

    def show
      slugs = %i{ruby csharp}
      @tracks = Track.where(slug: slugs)
    end

    def language
      @language_track = Track.find_by_slug!(params[:language])
      @part1_solution = @user_experiment.language_part(@language_track.slug, 1)
      @part2_solution = @user_experiment.language_part(@language_track.slug, 2)

    end

    private
    def set_user_experiment
      @experiment = Experiment.find(params[:id])
      @user_experiment = UserExperiment.find_by(user: current_user, experiment: @experiment)
    end
  end
end
