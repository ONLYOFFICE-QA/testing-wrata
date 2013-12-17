class CreateTestLists < ActiveRecord::Migration
  def change
    create_table :test_lists do |t|
      t.string :name
      t.integer :client_id

      t.timestamps
    end
  end
end
