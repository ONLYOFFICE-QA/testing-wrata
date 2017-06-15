class AddTotalResultsToHistory < ActiveRecord::Migration[4.2]
  def change
    add_column :histories, :total_text, :string
  end
end
