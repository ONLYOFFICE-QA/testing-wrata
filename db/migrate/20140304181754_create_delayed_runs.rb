class CreateDelayedRuns < ActiveRecord::Migration
  def change
    create_table :delayed_runs do |t|
      t.string :type
      t.datetime :start_time
      t.string :name
      t.string :method
      t.integer :client_id
      t.timestamps
    end
  end
end
