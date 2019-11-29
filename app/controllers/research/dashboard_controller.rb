module Research
  class DashboardController < Research::BaseController
    def index
      @experiments = Experiment.all
    end
  end
end
