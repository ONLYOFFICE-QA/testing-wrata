# frozen_string_literal: true

class AddUniqueIndexesToSeveralTables < ActiveRecord::Migration[7.1]
  def change
    add_index :clients, :login, unique: true
    add_index :spec_browsers, :name, unique: true
    add_index :spec_languages, :name, unique: true
  end
end
