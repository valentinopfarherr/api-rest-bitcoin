# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, inclusion: { in: %w[USD BTC] }

  def deduct(amount)
    update(balance: balance - amount)
  end

  def add(amount)
    update(balance: balance + amount)
  end

  private

  def sufficient_balance?(amount)
    balance >= amount
  end
end
