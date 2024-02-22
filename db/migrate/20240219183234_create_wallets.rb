# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.decimal :balance, precision: 20, scale: 8, default: 0.0
      t.string :currency
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
