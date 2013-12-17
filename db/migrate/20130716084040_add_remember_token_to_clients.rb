class AddRememberTokenToClients < ActiveRecord::Migration
  def change
    add_column :clients, :remember_token, :string
    add_index  :clients, :remember_token
  end
end
