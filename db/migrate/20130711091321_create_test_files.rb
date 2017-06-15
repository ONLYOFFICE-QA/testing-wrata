class CreateTestFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :test_files do |t|
      t.string :name
      t.integer :test_list_id

      t.timestamps
    end
  end
end
