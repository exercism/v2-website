server_identity_file = Rails.
  application.
  config_for("cluster")["server_identity_file"]

unless File.exist?(server_identity_file)
  raise "Server identity file isn't setup! Please see README.md"
end
