module Research
  class OmniauthCallbacksController < ::OmniauthCallbacksController
    def github
      super { |user| user.join_research! }
    end
  end
end
