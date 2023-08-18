# frozen_string_literal: true

class AddServerRunningTestColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :servers, :executing_command_now, :boolean, default: false, null: false
  end
end
