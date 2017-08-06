class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def create
     super do |user|
       if user.persisted?
         BootstrapsUser.bootstrap(user, session[:user_join_track_id])
       end
     end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :handle])
  end
end
