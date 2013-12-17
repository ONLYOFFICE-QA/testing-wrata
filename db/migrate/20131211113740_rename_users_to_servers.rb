class RenameUsersToServers < ActiveRecord::Migration
  def change
    rename_table :users, :servers
  end
end
