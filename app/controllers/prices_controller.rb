# frozen_string_literal: true

class PricesController < ApplicationController
  def bitcoin_price
    bitcoin_price = CoindeskService.fetch_bitcoin_price

    render json: { bitcoin_price: "#{bitcoin_price} USD" }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
