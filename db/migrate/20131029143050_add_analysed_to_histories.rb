# frozen_string_literal: true

class AddAnalysedToHistories < ActiveRecord::Migration[4.2]
  def change
    add_column :histories, :analysed, :boolean, default: false, null: false
  end
end
