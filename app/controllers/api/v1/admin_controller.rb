class Api::V1::AdminController < ApplicationController
    before_action :set_current_user, :authenticate_user!

    private

    def set_current_user
        auth_header = request.headers["Authorization"]
        token = auth_header.split(" ").last if auth_header

        return if token.blank?

        decoded_token = JwtService.decode(token)

        return if decoded_token.blank?

        return unless decoded_token[:token_type] == "access"

        @current_user = User.find_by(id: decoded_token[:user_id])
    end

    def current_user
        @current_user
    end

    def authenticate_user!
        return if current_user

        render json: { error: "Unauthorized" }, status: :unauthorized
    end

    def require_super_admin!
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.super_admin?
    end
end
