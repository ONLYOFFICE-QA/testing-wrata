# frozen_string_literal: true

class AddLocationInDelayedRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :delayed_runs, :location, :string
  end
end
