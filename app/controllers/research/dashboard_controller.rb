module Research
  class DashboardController < Research::BaseController
    def index
      redirect_to research_experiments_path
    end
  end
end
