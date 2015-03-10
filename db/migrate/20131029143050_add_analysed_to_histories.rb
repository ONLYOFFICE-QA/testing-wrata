class AddAnalysedToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :analysed, :boolean, default: false
  end
end
