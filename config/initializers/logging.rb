return unless Rails.env.development? || Rails.env.production?

Rails.application.configure do
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
  config.lograge.custom_options = lambda do |event|
    {
      remote_ip: event.payload[:remote_ip],
      request_id: event.payload[:request_id]
    }
  end

  config.lograge.custom_payload do |controller|
    {
      user_id: controller.current_user.try(:id)
    }
  end
end

Rails.logger = Rails.application.config.logger
