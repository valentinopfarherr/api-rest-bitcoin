# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.decimal :usd_balance, precision: 12, scale: 2, default: 0.0

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
