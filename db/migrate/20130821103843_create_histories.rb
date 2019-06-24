# frozen_string_literal: true

class CreateHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :histories do |t|
      t.string :file
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
  end
end
