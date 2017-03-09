class AddServerDefaultSize < ActiveRecord::Migration[5.0]
  def change
    change_column_default :servers, :size, '1gb'
  end
end
