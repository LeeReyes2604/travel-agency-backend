# frozen_string_literal: true

# Shared Redis client for short-lived authentication state (CAPTCHAs,
# invitations, and refresh tokens). Sidekiq keeps its own connection pool.
REDIS = Redis.new(url: ENV.fetch("REDIS_URL", "redis://redis:6379/0"))
