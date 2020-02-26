module Research
  class ExperimentSolutionsController < Research::BaseController
    def create
      experiment = Experiment.find(params[:experiment_id])

      # For now only use exercise a
      #exercise_slug = "#{params[:language]}-#{params[:part]}-#{%w{a b}.sample}"
      exercise_slug = "#{params[:language]}-#{params[:part]}-b"
      exercise = Exercise.find_by_slug!(exercise_slug)

      # Guard to ensure that someone doesn't try and access
      # a non-research solution through this method.
      raise "Incorrect exercise" unless exercise.track.research_track?

      solution = Research::CreateSolution.(
        current_user,
        experiment,
        exercise
      )

      redirect_to research_experiment_solution_path(solution)
    end

    def show
      @solution = current_user.research_experiment_solutions.find_by_uuid(params[:id])
      @exercise = @solution.exercise
      @editor_config = editor_config
      @syntax_highlighter_language = syntax_highlighter_language
    end

    def post_exercise_survey
      @solution = current_user.research_experiment_solutions.find_by_uuid(params[:id])
      @exercise = @solution.exercise
      render_modal("post_exercise_survey", "post_exercise_survey")
    end

    def submit
      solution = Research::ExperimentSolution.find_by(uuid: params[:id])
      solution.update!(difficulty_rating: params[:survey][:difficulty_rating])

      solution.submit!

      redirect_to research_user_experiment_path(solution.user_experiment)
    end

    private

    def track
      @track ||= Track.find_by(slug: @solution.language_slug)
    end

    def editor_config
      return {} unless track

      track.editor_config
    end

    def syntax_highlighter_language
      return unless track

      track.syntax_highlighter_language
    end
  end
end
