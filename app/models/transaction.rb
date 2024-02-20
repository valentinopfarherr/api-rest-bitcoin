# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user

  validates :transaction_type, presence: true
  validates :btc_amount, presence: true
  validates :usd_amount, presence: true
end
