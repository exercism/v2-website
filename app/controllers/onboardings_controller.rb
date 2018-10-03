class OnboardingsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_onboarded!

  def show
    if current_user.created_at < Exercism::V2_MIGRATED_AT
      redirect_to action: :migrate_to_v2
      return
    end
  end

  def migrate_to_v2
  end

  def update
    current_user.update!(
      accepted_privacy_policy_at: Time.current,
      accepted_terms_at: Time.current,
    )
    current_user.communication_preferences.update!(
      email_on_new_discussion_post: true,
      receive_product_updates: true
    )
    redirect_to action: :show
  end

  private

  def redirect_if_onboarded!
    if current_user.onboarded?
      redirect_to after_sign_in_path_for(:user)
    end
  end
end
