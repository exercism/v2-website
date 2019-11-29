module Research
  class SessionsController < ::SessionsController
    def create
      super { |user| user.join_research! }
    end
  end
end
