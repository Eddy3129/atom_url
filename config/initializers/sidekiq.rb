# frozen_string_literal: true

# config/initializers/sidekiq.rbRAILS_ENV=production bundle exec rails server

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') }
end
