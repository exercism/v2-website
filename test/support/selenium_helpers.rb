module SeleniumHelpers
  def self.hub_url
    Rails.application.config_for("selenium")["hub_url"]
  end

  def self.options
    self.hub_url.nil? ? {} : {url: self.hub_url}
  end

  def self.default_host
    Rails.application.config_for("selenium")["default_host"]
  end

  def self.teams_host
    Rails.application.config_for("selenium")["teams_host"]
  end

  def self.research_host
    Rails.application.config_for("selenium")["research_host"]
  end
end
