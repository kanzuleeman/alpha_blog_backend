# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception
  before_action :set_csrf_cookie

  helper_method :current_user

  def current_user
    @current_user = @current_user || User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-CSRF-Token'])
  end
  
  def user_not_authorized
    render json: { error: 'Not authorized' }, status: :forbidden
  end
  
end
