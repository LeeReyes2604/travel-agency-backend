# frozen_string_literal: true

class Api::V1::Admin::Auth::RegistrationsController < ApplicationController
  before_action :set_invited_user

  def show
    render json: {
      user: UserBlueprint.render_as_hash(@user),
      expires_in: RegistrationCodeService::EXPIRATION.to_i
    }
  end

  def update
    @user.assign_attributes(setup_params)
    @user.activated_at = Time.current

    if @user.save
      RegistrationCodeService.consume(@user)
      render json: { user: UserBlueprint.render_as_hash(@user) }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_invited_user
    @user = RegistrationCodeService.user_for(params[:code])
    return if @user

    render json: { error: "Invalid or expired registration code" }, status: :unprocessable_entity
  end

  def setup_params
    params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation)
  end
end
