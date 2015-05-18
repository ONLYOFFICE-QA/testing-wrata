class HistoriesLogToText < ActiveRecord::Migration
  def change
    change_column :histories, :log, :text
  end
end
