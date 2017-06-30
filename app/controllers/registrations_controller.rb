class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def create
     super do |user|
       return unless user.persisted?
       BootstrapsUser.bootstrap(user)
     end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
