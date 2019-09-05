Recaptcha.configure do |config|
  recaptcha_config = Rails.application.config_for("recaptcha")
  config.site_key = recaptcha_config["site_key"]
  config.secret_key = recaptcha_config["secret_key"]
end
