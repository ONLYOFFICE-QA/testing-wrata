# frozen_string_literal: true

class AddCompNameToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :comp_name, :string
  end
end
