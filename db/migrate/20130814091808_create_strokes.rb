class CreateStrokes < ActiveRecord::Migration
  def change
    create_table :strokes do |t|
      t.string :name
      t.integer :number
      t.integer :test_file_id

      t.timestamps
    end
  end
end
