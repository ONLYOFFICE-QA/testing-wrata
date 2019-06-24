# frozen_string_literal: true

class CreateSpecLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :spec_languages do |t|
      t.string :name

      t.timestamps
    end
  end
end
