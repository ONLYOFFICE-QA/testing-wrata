# frozen_string_literal: true

class AddLogToHistory < ActiveRecord::Migration[4.2]
  def change
    add_column :histories, :log, :string
  end
end
