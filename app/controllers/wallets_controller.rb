# frozen_string_literal: true

class WalletsController < ApplicationController
  include TransactionHelper

  before_action :authenticate_user
  before_action :set_wallet, only: %i[credit]

  def index
    render json: { wallets: wallets_info }, status: :ok
  end

  def credit
    amount = wallet_params[:amount].to_f
    currency = wallet_params[:currency]

    unless valid_amount?(amount)
      render json: { error: 'amount must be a positive number' }, status: :unprocessable_entity
      return
    end

    unless valid_currency?(currency)
      render json: { error: 'invalid currency' }, status: :unprocessable_entity
      return
    end

    update_wallet_balance(amount, currency)
  end

  private

  def set_wallet
    @wallet = current_user.wallets.find_by(currency: params[:currency])
  end

  def wallets_info
    current_user.wallets.map { |wallet| wallet_info(wallet) }
  end

  def wallet_info(wallet)
    { currency: wallet.currency, balance: format_amount(wallet.balance, wallet.currency) }
  end

  def wallet_params
    params.permit(:amount, :currency)
  end

  def valid_amount?(amount)
    amount.positive?
  end

  def valid_currency?(currency)
    %w[USD BTC].include?(currency)
  end

  def update_wallet_balance(amount, currency)
    @wallet.currency = currency
    @wallet.balance += format_amount(amount, currency)

    if @wallet.save
      render json: { message: "successfully credited #{format_amount(amount, currency)} #{currency} to the wallet", wallet: wallet_info(@wallet) }
    else
      render json: { error: 'failed to credit amount to the wallet' }, status: :unprocessable_entity
    end
  end
end
