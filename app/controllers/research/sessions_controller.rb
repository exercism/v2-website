module Research
  class SessionsController < ::SessionsController
    def create
      super { |user| user.join_research! }
    end

    def after_sign_in_path_for(resource)
      session["return_to"] || research_dashboard_path
    end
  end
end
