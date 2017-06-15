class RenameColumnToLastActivity < ActiveRecord::Migration[4.2]
  def change
    rename_column :servers, :last_test_run_date, :last_activity_date
  end
end
