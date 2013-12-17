class AddProjectToClient < ActiveRecord::Migration
  def change
    add_column :clients, :project, :string
  end
end
