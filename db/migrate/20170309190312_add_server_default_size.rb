# frozen_string_literal: true

class AddServerDefaultSize < ActiveRecord::Migration[5.0]
  def change
    change_column_default :servers, :size, from: nil, to: '1gb'
  end
end
