# frozen_string_literal: true

class RefreshTokenService
  EXPIRATION = 30.days
  KEY_PREFIX = "refresh_token:"

  class << self
    def issue(user)
      token = SecureRandom.urlsafe_base64(48)
      REDIS.set(key(token), user.id, ex: EXPIRATION.to_i)
      token
    end

    # Rotating a refresh token prevents a stolen old token from being reused.
    def rotate(token)
      user_id = consume(token)
      return unless user_id

      user = User.find_by(id: user_id)
      return unless user&.activated?

      [ user, issue(user) ]
    end

    def revoke(token)
      REDIS.del(key(token)) if token.present?
    end

    private

    def consume(token)
      return if token.blank?

      REDIS.getdel(key(token))
    end

    def key(token)
      "#{KEY_PREFIX}#{Digest::SHA256.hexdigest(token)}"
    end
  end
end
