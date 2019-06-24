# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name
      t.text :description
      t.string :address

      t.timestamps
    end
  end
end
