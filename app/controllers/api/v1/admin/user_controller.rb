# frozen_string_literal: true

class Api::V1::Admin::UserController < Api::V1::AdminController
  def show
    render json: { user: UserBlueprint.render_as_hash(current_user) }
  end

  def update
    user_params = params[:user][:password].present? ? user_password_params : user_profile_params
    Rails.logger.info("User params: #{user_params.inspect}")
    if current_user.update(user_params)
      render json: { user: UserBlueprint.render_as_hash(current_user) }
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_profile_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :username
    )
  end

  def user_password_params
    params.require(:user).permit(
      :password,
      :password_confirmation
    )
  end
  
end
