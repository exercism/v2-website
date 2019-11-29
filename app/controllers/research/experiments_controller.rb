module Research
  class ExperimentsController < Research::BaseController
    def index
      @experiments = Experiment.all
    end

    def show
      @experiment = Experiment.find(params[:id])
    end
  end
end
