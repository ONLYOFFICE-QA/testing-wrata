class CreateSpecBrowsers < ActiveRecord::Migration[5.1]
  def change
    create_table :spec_browsers do |t|
      t.string :name

      t.timestamps
    end
  end
end
