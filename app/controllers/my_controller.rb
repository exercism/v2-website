class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_onboarded!

  private

  def ensure_onboarded!
    return unless user_signed_in?
    unless current_user.onboarded?
      redirect_to onboarding_path
      false
    end
    true
  end
end
