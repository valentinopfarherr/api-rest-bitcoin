# frozen_string_literal: true

class TransactionsController < ApplicationController
  include TransactionHelper

  before_action :authenticate_user
  before_action :set_user
  before_action :set_transaction, only: [:show]
  before_action :set_sender_wallet, :set_receiver_wallet, only: [:create]

  def index
    @transactions = @user.transactions
    render json: { transactions: format_transactions(@transactions) }, status: :ok
  end

  def create
    service = TransactionCreationService.new(@user, transaction_params)

    begin
      @transaction = service.create_transaction
      render_transaction_created_response
    rescue StandardError => e
      render_error_response(e.message)
    end
  end

  def show
    render json: { transaction: format_transaction(@transaction) }, status: :ok
  end

  private

  def set_user
    @user = current_user
  end

  def set_transaction
    @transaction = @user.transactions.find_by(id: params[:id])
    render_not_found('transaction not found') unless @transaction
  end

  def set_sender_wallet
    @sender_wallet = @user.wallets.find_by(currency: transaction_params[:currency_sent])
  end

  def set_receiver_wallet
    @receiver_wallet = @user.wallets.find_by(currency: transaction_params[:currency_received])
  end

  def format_transactions(transactions)
    transactions.reverse.map { |transaction| format_transaction(transaction) }
  end

  def transaction_params
    params.require(:transaction).permit(:currency_sent, :currency_received, :amount_sent)
  end

  def render_transaction_created_response
    render json: { transaction: format_transaction(@transaction) }, status: :created
  end

  def render_transaction_error_response
    render json: { error: @transaction.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found(message)
    render json: { error: message }, status: :not_found
  end

  def render_error_response(message)
    render json: { error: message }, status: :unprocessable_entity
  end
end
