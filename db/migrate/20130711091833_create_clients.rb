# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[4.2]
  def change
    create_table :clients do |t|
      t.string :login
      t.string :password
      t.string :first_name
      t.string :second_name
      t.string :post

      t.timestamps
    end
  end
end
