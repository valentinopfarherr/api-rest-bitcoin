# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user

  validates :currency_sent, :currency_received, presence: true, inclusion: { in: %w[USD usd BTC btc] }
  validates :amount_sent, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
