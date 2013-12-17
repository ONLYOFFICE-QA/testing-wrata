class AddHistoryIdToStartOptions < ActiveRecord::Migration
  def change
    add_column :start_options, :history_id, :integer
  end
end
