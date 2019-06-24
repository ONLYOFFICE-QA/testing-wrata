# frozen_string_literal: true

class RenameColumnInHistory < ActiveRecord::Migration[4.2]
  def change
    rename_column :histories, :user_id, :server_id
  end
end
