class AddServerRunningTestColumn < ActiveRecord::Migration
  def change
    add_column :servers, :executing_command_now, :boolean, default: false
  end
end
