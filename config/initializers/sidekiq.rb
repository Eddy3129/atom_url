# frozen_string_literal: true

# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch['REDIS_URL'], namespace: 'myapp_production' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch['REDIS_URL'], namespace: 'myapp_production' }
end
