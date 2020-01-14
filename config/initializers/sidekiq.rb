Sidekiq.configure_server do |config|
  config.redis = { url: ENV['SIDEKIQ_WORKER_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['SIDEKIQ_WORKER_URL'] }
end
