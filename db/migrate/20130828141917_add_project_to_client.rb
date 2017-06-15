class AddProjectToClient < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :project, :string
  end
end
