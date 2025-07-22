class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      render json: { user: user }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  
  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  end
end
