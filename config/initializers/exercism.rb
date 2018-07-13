module Exercism
  V2_MIGRATED_AT = DateTime.new(2018, 7, 7, 12, 40)

  module Magic
    HandleRegexp = /^[a-zA-Z0-9-]+$/
  end
end

if Rails.env.production?
  Exercism::API_HOST = "https://api.exercism.io"
elsif Rails.env.test?
  Exercism::API_HOST = "https://test-api.exercism.io"
else
  Exercism::API_HOST = "https://localhost:3000/api"
end
