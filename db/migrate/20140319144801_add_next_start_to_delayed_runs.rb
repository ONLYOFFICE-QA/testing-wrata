class AddNextStartToDelayedRuns < ActiveRecord::Migration
  def change
    add_column :delayed_runs, :next_start, :datetime
  end
end
