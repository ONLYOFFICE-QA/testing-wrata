# frozen_string_literal: true

class CreateStrokes < ActiveRecord::Migration[4.2]
  def change
    create_table :strokes do |t|
      t.string :name
      t.integer :number
      t.integer :test_file_id

      t.timestamps
    end
  end
end
