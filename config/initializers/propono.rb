module Propono
  def self.configure_client
    Client.new do |config|
      creds = YAML::load(ERB.new(File.read("#{Rails.root}/config/propono.yml.erb")).result).stringify_keys
      creds = (creds[Rails.env]).symbolize_keys

      if creds[:use_iam_profile]
        config.use_iam_profile = true
      else
        config.access_key = creds[:access_key]
        config.secret_key = creds[:secret_key]
      end
      config.queue_region = creds[:queue_region]
      config.queue_suffix = creds[:queue_suffix] || ""
      config.application_name = creds[:application_name]
      config.logger = Rails.logger
    end
  end
end

