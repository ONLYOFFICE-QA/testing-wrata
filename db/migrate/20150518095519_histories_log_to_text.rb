# frozen_string_literal: true

class HistoriesLogToText < ActiveRecord::Migration[4.2]
  def change
    change_column :histories, :log, :text
  end
end
