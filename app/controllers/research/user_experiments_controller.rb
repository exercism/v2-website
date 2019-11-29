module Research
  class UserExperimentsController < Research::BaseController
    before_action :set_user_experiment, except: [:create]

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
    end

    def language
      @language_slug = params[:language]
      @language_title = Track.find_by_slug(@language_slug).title
      @part_1_solution = @user_experiment.solutions.where('exercises.slug': ["#{@language_slug}-a-1", "#{@language_slug}-a-1"]).first
      @part_2_solution = @user_experiment.solutions.where('exercises.slug': ["#{@language_slug}-a-2", "#{@language_slug}-b-2"]).first
    end

    private
    def set_user_experiment
      @experiment = Experiment.find(params[:id])
      @user_experiment = UserExperiment.find_by(user: current_user, experiment: @experiment)
    end
  end
end
