class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    @user = AuthenticatesUserFromOmniauth.authenticate(request.env["omniauth.auth"], session[:user_join_track_id])
    sign_in_and_redirect @user, event: :authentication
  #rescue
  #  session["devise.github_data"] = request.env["omniauth.auth"]
  #  redirect_to new_user_registration_url
  end

  def failure
    redirect_to root_path
  end
end
