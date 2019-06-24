# frozen_string_literal: true

class RemoveAnalysedFromHistories < ActiveRecord::Migration[5.0]
  def change
    remove_column :histories, :analysed, :boolean
  end
end
