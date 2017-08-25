module ClusterConfig
  def self.num_webservers
    Rails.application.config_for("cluster")["num_webservers"]
  end
end
