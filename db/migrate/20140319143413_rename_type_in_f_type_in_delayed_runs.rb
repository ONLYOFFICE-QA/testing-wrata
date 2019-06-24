# frozen_string_literal: true

class RenameTypeInFTypeInDelayedRuns < ActiveRecord::Migration[4.2]
  def change
    rename_column :delayed_runs, :type, :f_type
  end
end
