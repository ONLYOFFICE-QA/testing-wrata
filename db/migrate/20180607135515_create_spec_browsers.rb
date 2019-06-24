# frozen_string_literal: true

class CreateSpecBrowsers < ActiveRecord::Migration[5.1]
  def change
    create_table :spec_browsers do |t|
      t.string :name

      t.timestamps
    end

    add_column :start_options, :spec_browser, :string
  end
end
