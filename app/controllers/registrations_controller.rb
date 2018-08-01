class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  layout :layout_from_site_context

  def create
     super do |user|
       if user.persisted?
         BootstrapUser.(user, session[:user_join_track_id])
       end
     end
  end

  def after_inactive_sign_up_path_for(resource)
    confirmation_required_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :handle])
  end
end
