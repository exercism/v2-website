module Research
  class UserExperimentsController < Research::BaseController
    before_action :set_user_experiment, except: [:create]

    def create
      experiment = Experiment.find(params[:experiment_id])
      user_experiment = CreateUserExperiment.(current_user, experiment)
      redirect_to research_user_experiment_path(user_experiment)
    end

    def show
      slugs = %i{csharp elm go javascript python ruby rust x86-64-assembly}
      @tracks = Track.where(slug: slugs)
      @tracks = @tracks.sort do |track_1, track_2|
        if @user_experiment.language_in_progress?(track_1.slug)
          if @user_experiment.language_in_progress?(track_2.slug)
            track_1.slug <=> track_2.slug
          else
            -1
          end
        elsif @user_experiment.language_completed?(track_1.slug)
          if @user_experiment.language_completed?(track_2.slug)
            track_1.slug <=> track_2.slug
          else
            -1
          end
        else
          if @user_experiment.language_started?(track_2.slug)
            1
          else
            track_1.slug <=> track_2.slug
          end
        end
      end
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
