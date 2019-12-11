module Research
  class ExperimentSolutionsController < Research::BaseController
    def create
      experiment = Experiment.find(params[:experiment_id])

      # For now only use exercise a
      #exercise_slug = "#{params[:language]}-#{params[:part]}-#{%w{a b}.sample}"
      exercise_slug = "#{params[:language]}-#{params[:part]}-a"
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
      @editor_config = editor_config
    end

    def submit
      solution = Research::ExperimentSolution.find_by(uuid: params[:id])

      solution.submit!

      redirect_to language_research_user_experiment_path(
        solution.user_experiment,
        solution.language_slug
      )
    end

    private

    def editor_config
      return {} unless track = Track.find_by(slug: @solution.language_slug)

      track.editor_config
    end
  end
end
