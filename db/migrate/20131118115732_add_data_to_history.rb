class AddDataToHistory < ActiveRecord::Migration
  def change
    add_column :histories, :data, :binary
  end
end
