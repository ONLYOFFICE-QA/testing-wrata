class AddStatusOnServer < ActiveRecord::Migration[4.2]
  def change
    add_column :servers, :_status, :string, default: 'normal'
  end
end
