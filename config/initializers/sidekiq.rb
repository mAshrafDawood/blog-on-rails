redis_url = "redis://:#{ENV['BLOG_ON_RAILS_REDIS_PASSWORD']}@#{ENV['BLOG_ON_RAILS_REDIS_HOST']}:#{ENV['BLOG_ON_RAILS_REDIS_PORT']}/0"

Sidekiq.configure_server do |config|
    config.redis = { url: redis_url || 'redis://localhost:6379/0'}
end

Sidekiq.configure_client do |config|
    config.redis = { url: redis_url || 'redis://localhost:6379/0'}
end