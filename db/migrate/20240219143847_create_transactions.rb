# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :btc_amount, precision: 20, scale: 8
      t.decimal :usd_amount, precision: 12, scale: 2
      t.decimal :btc_usd_price, precision: 12, scale: 2

      t.timestamps
    end
  end
end
