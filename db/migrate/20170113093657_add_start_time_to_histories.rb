# frozen_string_literal: true

class AddStartTimeToHistories < ActiveRecord::Migration[5.0]
  def change
    add_column :histories, :start_time, :datetime
  end
end
