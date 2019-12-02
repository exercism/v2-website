module Research
  class PagesController < BaseController
    skip_before_action :authenticate_user!
    skip_before_action :check_user_joined_research!

    def index
      redirect_to research_dashboard_path if user_signed_in?
    end
  end
end
