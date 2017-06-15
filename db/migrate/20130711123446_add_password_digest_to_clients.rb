class AddPasswordDigestToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :password_digest, :string
  end
end
