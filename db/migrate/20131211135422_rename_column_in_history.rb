class RenameColumnInHistory < ActiveRecord::Migration
  def change
    rename_column :histories, :user_id, :server_id
  end
end
