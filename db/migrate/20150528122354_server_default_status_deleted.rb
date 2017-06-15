class ServerDefaultStatusDeleted < ActiveRecord::Migration[4.2]
  def change
    change_column :servers, :_status, :string, default: 'destroyed'
  end
end
