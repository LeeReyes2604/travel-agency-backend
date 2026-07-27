# frozen_string_literal: true

class Api::V1::Admin::Auth::SessionsController < ApplicationController
    def create
        unless result =verify_recaptcha(response: params[:recaptcha_token])
            return render json: { error: "reCAPTCHA verification failed" }, status: :unprocessable_entity
        end

        user = User.find_by(email: params[:email])

        unless user&.activated? && user.authenticate(params[:password])
            return render json: { error: "Invalid credentials" }, status: :unauthorized
        end

        render json: authentication_payload(user), status: :ok
    end

    def refresh
        user, refresh_token = RefreshTokenService.rotate(params[:refresh_token])

        unless user
            return render json: { error: "Invalid or expired refresh token" }, status: :unauthorized
        end

        render json: authentication_payload(user, refresh_token: refresh_token), status: :ok
    end

    def destroy
        RefreshTokenService.revoke(params[:refresh_token])
        head :no_content
    end

    private

    def authentication_payload(user, refresh_token: RefreshTokenService.issue(user))
        {
            token: JwtService.encode(user_id: user.id),
            refresh_token: refresh_token,
            user: UserBlueprint.render_as_hash(user)
        }
    end
end
