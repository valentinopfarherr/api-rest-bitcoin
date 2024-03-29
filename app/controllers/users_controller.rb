# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'user created successfully' }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
