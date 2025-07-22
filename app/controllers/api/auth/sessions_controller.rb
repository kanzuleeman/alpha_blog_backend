module Api
  module Auth
    class SessionsController < ApplicationController
      
      protect_from_forgery with: :null_session

      def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          render json: { user: user }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def show
        if current_user
          render json: {
            id: current_user.id,
            email: current_user.email,
            role: current_user.role  # 👈 MAKE SURE THIS IS INCLUDED
          }
        else
          render json: {}, status: :unauthorized
        end
      end
      

      def destroy
        # Clear the session
        session.clear
        # Or if using Devise: sign_out(current_user)
        render json: { message: 'Logged out successfully' }
      end
    end
  end
end
