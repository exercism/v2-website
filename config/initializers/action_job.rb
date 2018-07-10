Rails.application.config.active_job.queue_adapter = :sidekiq
Sidekiq.configure_client do |config|
  config.redis = { url: Rails.application.secrets.redis_url } if Rails.env.production?
end
