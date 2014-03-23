class AddLocationInDelayedRuns < ActiveRecord::Migration
  def change
    add_column :delayed_runs, :location, :string
  end
end
