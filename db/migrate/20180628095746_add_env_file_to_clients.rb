class AddEnvFileToClients < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :env_file, :string, default: ''
  end
end
