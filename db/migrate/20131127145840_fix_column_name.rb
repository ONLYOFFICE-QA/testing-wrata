class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :histories, :total_text, :total_result
  end
end
