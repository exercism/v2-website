class Mentor::AnalysesController < MentorController
  def index
    @analyses = IterationAnalysis.includes(iteration: {solution: {exercise: :track}}).
                                  order('id DESC').
                                  page(params[:page]).per(20)
  end

  def show
    @analysis = IterationAnalysis.find(params[:id])
  end
end
