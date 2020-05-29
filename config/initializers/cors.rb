Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/git_api', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head], expose: %w(Allow ETag Link Warning)
    resource '/git_api/*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head], expose: %w(Allow ETag Link Warning)
  end
end
