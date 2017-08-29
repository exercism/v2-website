module ClusterConfig
  def self.num_webservers
    Rails.application.config_for("cluster")["num_webservers"]
  end

  def self.server_identity
    File.read(server_identity_file).chomp
  end

  def self.server_identity_file
    Rails.application.config_for("cluster")["server_identity_file"]
  end

  private_class_method :server_identity_file
end
