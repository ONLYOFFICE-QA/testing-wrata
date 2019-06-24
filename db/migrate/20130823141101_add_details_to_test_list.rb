# frozen_string_literal: true

class AddDetailsToTestList < ActiveRecord::Migration[4.2]
  def change
    add_column :test_lists, :branch, :string
    add_column :test_lists, :project, :string
  end
end
