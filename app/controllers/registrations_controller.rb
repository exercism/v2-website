class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :check_recaptcha!, only: [:create]

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

  private

  def check_recaptcha!
    return if recaptcha_verified? || recaptcha_fallback_verified?

    clean_up_resource
    render :new
  end

  def recaptcha_verified?
    build_resource(sign_up_params)

    verify_recaptcha(
      secret_key: RecaptchaConfig.secret_key,
      model: resource,
      action: "registration",
      minimum_score: 0.5
    )
  end

  def recaptcha_fallback_verified?
    build_resource(sign_up_params)

    verify_recaptcha(
      model: resource,
      secret_key: RecaptchaConfig.fallback_secret_key
    )
  end

  def clean_up_resource
    clean_up_passwords(resource)
    set_minimum_password_length
  end
end
