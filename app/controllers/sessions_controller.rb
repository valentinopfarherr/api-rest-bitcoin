# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authenticate_user, only: [:destroy]

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      render json: { message: 'login successful' }, status: :ok
    else
      render json: { error: 'invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil
    render json: { message: 'logged out successfully' }
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
