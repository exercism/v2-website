class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_onboarded!

  private

  def ensure_onboarded!
    unless current_user.onboarded?
      redirect_to onboarding_path
    end
  end
end
