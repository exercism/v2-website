module Research
  class DashboardController < Research::BaseController
    before_action :authenticate_user!
    before_action :check_user_joined_research!

    def index
      @experiments = Experiment.all
    end

    private

    def check_user_joined_research!
      redirect_to research_join_path unless current_user.joined_research?
    end
  end
end
