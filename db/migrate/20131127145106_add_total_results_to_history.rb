class AddTotalResultsToHistory < ActiveRecord::Migration
  def change
    add_column :histories, :total_text, :string
  end
end
