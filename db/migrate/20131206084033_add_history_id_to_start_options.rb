# frozen_string_literal: true

class AddHistoryIdToStartOptions < ActiveRecord::Migration[4.2]
  def change
    add_column :start_options, :history_id, :integer
  end
end
