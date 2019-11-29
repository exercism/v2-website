module Research
  class JoinsController < BaseController
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
