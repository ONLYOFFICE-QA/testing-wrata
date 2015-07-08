class ServerDefaultStatusDeleted < ActiveRecord::Migration
  def change
    change_column :servers, :_status, :string, default: 'destroyed'
  end
end
