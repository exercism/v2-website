class SessionsController < Devise::SessionsController
  def create
    super
  rescue BCrypt::Errors::InvalidHash
    redirect_to new_user_session_path, alert: "Your account does not have a password. Please use oauth."
  end
end
