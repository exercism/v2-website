module Research
  class SessionsController < ::SessionsController
    def create
      super { |user| user.join_research! }

      session["return_to"] ||= research_dashboard_path
    end
  end
end
