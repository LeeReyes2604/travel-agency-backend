# frozen_string_literal: true

class RegistrationCodeService
  EXPIRATION = 5.minutes
  KEY_PREFIX = "registration_code:"

  class << self
    def issue(user)
      code = SecureRandom.urlsafe_base64(32)
      REDIS.set(key(user.id), code, ex: EXPIRATION.to_i)
      "#{user.id}.#{code}"
    end

    def user_for(token)
      user_id, code = token.to_s.split(".", 2)
      return if user_id.blank? || code.blank?

      expected_code = REDIS.get(key(user_id))
      return unless expected_code.present? && ActiveSupport::SecurityUtils.secure_compare(expected_code, code)

      User.find_by(id: user_id)
    end

    def consume(user)
      REDIS.del(key(user.id))
    end

    private

    def key(user_id)
      "#{KEY_PREFIX}#{user_id}"
    end
  end
end
