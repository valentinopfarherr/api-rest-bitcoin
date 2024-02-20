# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user
    return if logged_in?

    render json: { error: 'you must be logged in to access this page' }, status: :unauthorized
  end

  def logged_in?
    !!session[:user_id]
  end
end
