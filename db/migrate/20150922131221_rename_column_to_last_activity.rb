class RenameColumnToLastActivity < ActiveRecord::Migration
  def change
    rename_column :servers, :last_test_run_date, :last_activity_date
  end
end
