class AddNextStartToDelayedRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :delayed_runs, :next_start, :datetime
  end
end
