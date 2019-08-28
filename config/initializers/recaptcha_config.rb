module RecaptchaConfig
  mattr_accessor :site_key, :secret_key, :fallback_site_key, :fallback_secret_key

  def self.configure
    yield(self)
  end
end

RecaptchaConfig.configure do |config|
  recaptcha_config = Rails.application.config_for("recaptcha")

  config.site_key = recaptcha_config["site_key"]
  config.secret_key = recaptcha_config["secret_key"]
  config.fallback_site_key = recaptcha_config["fallback_site_key"]
  config.fallback_secret_key = recaptcha_config["fallback_secret_key"]
end
