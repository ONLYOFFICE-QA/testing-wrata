# frozen_string_literal: true

class ServerDefaultStatusDeleted < ActiveRecord::Migration[4.2]
  def up
    change_column :servers, :_status, :text, default: 'destroyed'
  end

  def down
    change_column :servers, :_status, :text, default: 'normal'
  end
end
