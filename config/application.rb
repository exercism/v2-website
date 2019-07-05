require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Exercism
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.active_job.queue_adapter = :delayed_job
  end

  def self.configure_logging(config)
    # Move production log into a system folder
    log_prefix = Rails.env.production? ? "/var/log/exercism/exercism_" : "log/"

    rails_log_file = "#{log_prefix}#{Rails.env}.log"
    logger         = ActiveSupport::Logger.new(rails_log_file, "daily")
    config.logger  = ActiveSupport::TaggedLogging.new(logger)

    # Create a lograge event log
    requests_log_file = "#{log_prefix}requests.log"
    requests_logger   = ActiveSupport::Logger.new(requests_log_file, "daily")
    event_logger      = ActiveSupport::TaggedLogging.new(requests_logger)

    config.lograge.keep_original_rails_log = true
    config.lograge.enabled = true
    config.lograge.logger = event_logger
    config.lograge.custom_payload do |controller|
      {
        remote_ip: controller.request.remote_ip,
        request_id: controller.request.uuid,
        user_id: controller.current_user.try(:id)
      }
    end
  end
end
