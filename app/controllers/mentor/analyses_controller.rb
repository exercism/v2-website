class Mentor::AnalysesController < MentorController
  def index
    @tracks = Track.where(id: IterationAnalysis.joins(iteration: {person_solution: :exercise}).where('iterations.solution_type': "Solution").select("exercises.track_id"))

    @track_id = params[:track_id]
    @analyses = IterationAnalysis.includes(iteration: {solution: {exercise: :track}}).
                                  order('id DESC')

    @analyses = @analyses.joins(iteration: {person_solution: :exercise}).where('exercises.track_id': @track_id) if @track_id.to_i > 0
    @analyses = @analyses.page(params[:page]).per(20)
  end

  def show
    @analysis = IterationAnalysis.find(params[:id])
  end

  def replay
    @analysis = IterationAnalysis.find(params[:id])
    ProcessNewIterationJob.perform_now(@analysis.iteration)
    redirect_to({action: :show}, notice: "Rerunning analysis")
  end
end
