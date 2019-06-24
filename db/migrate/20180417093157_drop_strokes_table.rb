# frozen_string_literal: true

class DropStrokesTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :strokes do |t|
      t.string :name, null: false
      t.integer :number, null: false
      t.integer :test_file_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
