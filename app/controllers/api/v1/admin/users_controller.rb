# frozen_string_literal: true

class Api::V1::Admin::UsersController < Api::V1::AdminController
  before_action :require_super_admin!
  before_action :set_user, only: [ :update, :destroy ]

  def index
    users = User.order(created_at: :desc)
                .page(params[:page])
                .per(10)

    render json: {
      users: UserBlueprint.render_as_hash(users),
      meta: {
        current_page: users.current_page,
        total_pages: users.total_pages,
        total_count: users.total_count
      }
    }
  end

  def create
    user = User.new(invitation_params)

    if user.save
      code = RegistrationCodeService.issue(user)

      render json: {
        user: UserBlueprint.render_as_hash(user),
        registration_code: code,
        registration_url: api_v1_admin_auth_registration_url(code: code)
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: UserBlueprint.render_as_hash(@user)
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      return render json: { error: "You cannot delete your own account" }, status: :unprocessable_entity
    end

    if @user.destroy
      render json: { message: "User deleted" }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :username,
      :password,
      :password_confirmation,
      :role
    )
  end

  def invitation_params
    params.require(:user).permit(:email, :first_name, :last_name, :role)
  end
end
