module Propono
  def self.configure_client
    Client.new do |config|
      config.access_key = Rails.application.secrets.aws_access_key_id
      config.secret_key = Rails.application.secrets.aws_secret_access_key
      config.queue_region = Rails.application.secrets.aws_region
      config.queue_suffix = Rails.env.production?? "" : "-#{Rails.env}"
      config.application_name = Rails.env.production?? "exercism_website" :
                                                       "exercism_website_#{Rails.env}_#{`whoami`.strip}"

      config.slow_queue_enabled = false
      config.logger = Rails.logger
    end
  end
end
