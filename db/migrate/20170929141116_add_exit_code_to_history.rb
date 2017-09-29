class AddExitCodeToHistory < ActiveRecord::Migration[5.1]
  def change
    add_column :histories, :exit_code, :integer
  end
end
