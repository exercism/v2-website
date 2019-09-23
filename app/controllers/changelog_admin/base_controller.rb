module ChangelogAdmin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :check_feature_enabled!
    before_action :check_authorization!

    layout "changelog_admin"

    private

    def check_feature_enabled!
      unless Flipper[:changelog].enabled?(current_user)
        return redirect_to root_path, status: 401
      end
    end

    def check_authorization!
      unless current_user.may_edit_changelog?
        return redirect_to root_path, status: 401
      end
    end
  end
end
