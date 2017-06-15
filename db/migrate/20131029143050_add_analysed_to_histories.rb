class AddAnalysedToHistories < ActiveRecord::Migration[4.2]
  def change
    add_column :histories, :analysed, :boolean, default: false
  end
end
