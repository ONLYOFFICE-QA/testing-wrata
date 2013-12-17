class AddCompNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :comp_name, :string
  end
end
