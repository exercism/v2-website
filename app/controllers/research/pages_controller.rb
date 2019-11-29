module Research
  class PagesController < BaseController
    def home
      redirect_to research_dashboard_path if user_signed_in?
    end
  end
end
