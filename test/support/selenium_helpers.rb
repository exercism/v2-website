SELENIUM_HELPERS_CONFIG = Rails.application.config_for("selenium").reduce({}, :merge).freeze
module SeleniumHelpers
  def self.hub_url
    SELENIUM_HELPERS_CONFIG["hub_url"]
  end

  def self.options
    self.hub_url.nil? ? {} : {url: self.hub_url}
  end

  def self.default_host
    SELENIUM_HELPERS_CONFIG["default_host"]
  end

  def self.teams_host
    SELENIUM_HELPERS_CONFIG["teams_host"]
  end
end
