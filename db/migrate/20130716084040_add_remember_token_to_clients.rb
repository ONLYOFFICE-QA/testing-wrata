# frozen_string_literal: true

class AddRememberTokenToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :remember_token, :string
    add_index :clients, :remember_token
  end
end
