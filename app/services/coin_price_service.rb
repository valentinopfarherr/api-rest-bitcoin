# frozen_string_literal: true

require 'httparty'

class CoindeskService
  BASE_URL = 'https://api.coindesk.com/v1/bpi/currentprice.json'

  def self.fetch_bitcoin_price
    response = HTTParty.get(BASE_URL)
    parsed_response = JSON.parse(response.body)

    parsed_response['bpi']['USD']['rate'].to_f
  rescue HTTParty::Error => e
    Rails.logger.error("Error al obtener el precio del Bitcoin: #{e.message}")
    raise StandardError, 'Error al obtener el precio del Bitcoin.'
  end
end
