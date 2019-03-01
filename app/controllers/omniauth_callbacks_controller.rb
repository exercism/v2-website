class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def github
    @user = AuthenticateUserFromOmniauth.(request.env["omniauth.auth"], session[:user_join_track_id])
    remember_me(@user)
    sign_in_and_redirect @user, event: :authentication
  rescue
    session["devise.github_data"] = request.env["omniauth.auth"]
    redirect_to new_user_registration_url, alert: "Sorry, we could not authenticate you from GitHub. Check the <a href='#{faqs_page_path}'>FAQs</a> for for info."
  end

  def failure
    redirect_to root_path
  end
end
