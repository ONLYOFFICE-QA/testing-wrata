class FixColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :histories, :total_text, :total_result
  end
end
