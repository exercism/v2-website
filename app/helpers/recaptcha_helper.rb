module RecaptchaHelper
  def recaptcha_widget(resource, opts)
    if recaptcha_failed?(resource)
      recaptcha_fallback(opts)
    else
      recaptcha_default(opts)
    end
  end

  private

  def recaptcha_failed?(resource)
    resource.
      errors[:base].
      include?(I18n.t("recaptcha.errors.verification_failed"))
  end

  def recaptcha_default(opts)
    opts = opts.merge(site_key: RecaptchaConfig.site_key)

    recaptcha_v3(opts)
  end

  def recaptcha_fallback(opts)
    opts = opts.merge(site_key: RecaptchaConfig.fallback_site_key)

    recaptcha_tags(opts)
  end
end
