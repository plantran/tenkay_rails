REDIS_CLIENT = Redis.new(url: Rails.application.config_for(:redis).cache_url, timeout: 1)
