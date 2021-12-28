# frozen_string_literal: true

class HistoriesLogToText < ActiveRecord::Migration[4.2]
  def up
    change_column :histories, :log, :text
  end

  def down
    change_column :histories, :log, :string
  end
end
