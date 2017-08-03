Rails.application.config.active_job.queue_adapter = :sidekiq
Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://processor.exercism.io:6379/0' } if Rails.env.production?
end
