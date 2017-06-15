class RenameUsersToServers < ActiveRecord::Migration[4.2]
  def change
    rename_table :users, :servers
  end
end
