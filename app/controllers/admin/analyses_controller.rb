class Admin::AnalysesController < AdminController
  skip_before_action :restrict_to_authorised!

  def index
    @tracks = Track.where(id: IterationAnalysis.joins(iteration: {person_solution: :exercise}).where('iterations.solution_type': "Solution").select("exercises.track_id"))

    @track_id = params[:track_id]
    @ops_status = params[:ops_status]
    @analysis_status = params[:analysis_status]

    @analyses = IterationAnalysis.includes(iteration: {solution: {exercise: :track}}).
                                  order('id DESC')

    @analyses = @analyses.joins(iteration: {person_solution: :exercise}).where('exercises.track_id': @track_id) if @track_id.to_i > 0
    @analyses = @analyses.where(ops_status: @ops_status) if @ops_status.present?
    @analyses = @analyses.where(analysis_status: @analysis_status) if @analysis_status.present?
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
