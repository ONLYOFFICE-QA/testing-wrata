class AddLogToHistory < ActiveRecord::Migration
  def change
    add_column :histories, :log, :string
  end
end
