# frozen_string_literal: true

require 'httparty'

class CoindeskService
  BASE_URL = ENV['COINDESK_URL']

  def self.fetch_bitcoin_price
    response = HTTParty.get(BASE_URL)
    parsed_response = JSON.parse(response.body)

    parsed_response['bpi']['USD']['rate'].gsub(',', '').to_f
  rescue HTTParty::Error => e
    Rails.logger.error("error getting Bitcoin price: #{e.message}")
    raise StandardError, 'error getting Bitcoin price.'
  end
end
