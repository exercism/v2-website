module Research
  class JoinsController < BaseController
    before_action :authenticate_user!
    before_action :check_user_joined_research!

    def show
    end

    def create
      current_user.join_research!

      redirect_to research_dashboard_path
    end

    private

    def check_user_joined_research!
      redirect_to research_dashboard_path if current_user.joined_research?
    end
  end
end
