# frozen_string_literal: true

class User < ApplicationRecord
  after_create :create_default_wallets

  has_secure_password

  has_many :wallets, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, :password_confirmation, presence: true, on: :create

  private

  def create_default_wallets
    Wallet.create(user_id: id, currency: 'USD', balance: 0)
    Wallet.create(user_id: id, currency: 'BTC', balance: 0)
  end
end
