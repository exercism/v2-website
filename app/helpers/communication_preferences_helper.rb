module CommunicationPreferencesHelper
  def communication_preference_option(f, key)
    f.label key do 
      f.check_box(key) +
      content_tag(:span, I18n.t("communication_preferences.#{key}"))
    end
  end
end
