redis_config = Rails.application.config_for(:redis)

Sidekiq.configure_server do |config|
  config.redis = redis_config[:sidekiq]
end

Sidekiq.configure_client do |config|
  config.redis = redis_config[:sidekiq]
end
