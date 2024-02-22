# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    render json: { error: 'resource not found' }, status: :not_found
  end
end
