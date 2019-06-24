# frozen_string_literal: true

class AddSpecLanguageToStartOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :start_options, :spec_language, :string
  end
end
