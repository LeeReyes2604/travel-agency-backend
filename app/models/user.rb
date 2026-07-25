# frozen_string_literal: true

class User < ApplicationRecord
    has_secure_password validations: false

    validates :email, presence: true, uniqueness: true,
               format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username,
              presence: true,
              uniqueness: true,
              length: { in: 3..20 },
              format: {
                with: /\A[a-zA-Z0-9_-]+\z/,
                message: "can only contain letters, numbers, underscore, and hyphen"
              },
              if: :activated?
    validates :password, confirmation: true, if: -> { activated? && password }  
    validates :password, length: { minimum: 6 }, if: -> { activated? && password }  
    validate :profile_is_complete_on_activation

    enum role: { super_admin: 0, admin: 1 }

    before_save :downcase_email

    def activated?
        activated_at.present?
    end

    private

    def profile_is_complete_on_activation
        return unless will_save_change_to_activated_at? && activated?

        errors.add(:first_name, "can't be blank") if first_name.blank?
        errors.add(:last_name, "can't be blank") if last_name.blank?
        errors.add(:password, "can't be blank") if password_digest.blank?
    end

    def downcase_email
        self.email = email.downcase
    end
end
