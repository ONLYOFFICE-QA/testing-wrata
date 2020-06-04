# frozen_string_literal: true

class RemoveFTypeFromDelayRun < ActiveRecord::Migration[6.0]
  def up
    change_table :delayed_runs, bulk: true do |t|
      t.remove :f_type
    end
  end

  def down
    change_table :delayed_runs, bulk: true do |t|
      t.string :f_type
    end
  end
end
