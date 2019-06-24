# frozen_string_literal: true

class AddServerSelfDestroyBoolean < ActiveRecord::Migration[4.2]
  def change
    add_column :servers, :self_destruction, :boolean, default: true
  end
end
