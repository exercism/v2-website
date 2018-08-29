module SettingsHelper
  def settings_bar
    selected = case controller_name
      when "communication_preferences"
        :preferences
      when "track_settings"
        :track_settings
      else
        :settings
      end
    render "layouts/settings_bar", selected: selected
  end
end
