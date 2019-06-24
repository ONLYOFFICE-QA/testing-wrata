# frozen_string_literal: true

class AddDataToHistory < ActiveRecord::Migration[4.2]
  def change
    add_column :histories, :data, :binary
  end
end
