class RenameTypeInFTypeInDelayedRuns < ActiveRecord::Migration

  def change
    rename_column :delayed_runs, :type, :f_type
  end

end
