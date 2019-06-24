# frozen_string_literal: true

class AddIsVerifiedToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :verified, :boolean, default: false
  end
end
