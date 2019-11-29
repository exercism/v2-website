module Research
  class ExperimentSolutionsController < Research::BaseController
    def create
      experiment = Experiment.find(params[:experiment_id])

      # TODO - Remove this placeholder
      exercise = Exercise.find_by(slug: "two-fer", track: Track.find_by_slug("ruby"))

      # TODO - Check this is on the experiment track etc
      #exercise_slug = "#{params[:language]}_#{%w{a b}.sample}_#{part}"
      #exercise = Exercise.find_by_slug!(exercise_slug)

      solution = Research::CreateSolution.(
        current_user,
        experiment,
        exercise
      )

      redirect_to research_experiment_solution_path(solution)
    end

    def show
      @solution = current_user.research_experiment_solutions.find_by_uuid(params[:id])
    end
  end
end
